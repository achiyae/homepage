require "date"
require "jekyll"

# Validates structured front matter (news, members, alumni, highlights) so that
# mistakes fail the build with a message naming the file, item number and field.
module ContentValidation
  class Error < StandardError; end

  KINDS = %w[paper talk software].freeze

  module_function

  def blank?(value)
    value.nil? || value.to_s.strip.empty?
  end

  def fail_at(file, label, index, field, problem)
    raise Error, "#{file}: #{label} item #{index + 1}: #{problem} `#{field}`"
  end

  def require_fields(items, file, label, fields)
    raise Error, "#{file}: `#{label}` must be a list" unless items.is_a?(Array)

    items.each_with_index do |item, i|
      fail_at(file, label, i, fields.first, "expected a mapping with") unless item.is_a?(Hash)
      fields.each { |f| fail_at(file, label, i, f, "missing required field") if blank?(item[f]) }
    end
  end

  def normalize_news(items, file)
    require_fields(items, file, "news", %w[date title])
    items.each_with_index.map do |item, i|
      item.merge("date" => parse_date(item["date"], file, i))
    end.sort_by { |item| item["date"] }.reverse
  end

  def parse_date(value, file, index)
    return value if value.instance_of?(Date)
    return value.to_date if value.respond_to?(:to_date) && !value.is_a?(String)

    str = value.to_s
    fail_at(file, "news", index, "date", "invalid (use YYYY-MM-DD)") unless str.match?(/\A\d{4}-\d{2}-\d{2}\z/)
    Date.strptime(str, "%Y-%m-%d")
  rescue Date::Error
    fail_at(file, "news", index, "date", "invalid (use YYYY-MM-DD)")
  end

  def validate_people(items, file, key)
    require_fields(items, file, key, %w[name role])
    items
  end

  def validate_highlights(items, file)
    require_fields(items, file, "highlights", %w[title summary link])
    items.each_with_index do |item, i|
      next if item["kind"].nil? || KINDS.include?(item["kind"])

      fail_at(file, "highlights", i, "kind", "invalid (one of #{KINDS.join(', ')}) for")
    end
    items
  end

  class Generator < Jekyll::Generator
    safe true
    priority :high

    def generate(site)
      site.pages.each do |page|
        data = page.data
        file = page.path
        data["news"] = ContentValidation.normalize_news(data["news"], file) if data.key?("news")
        %w[members alumni].each do |key|
          ContentValidation.validate_people(data[key], file, key) if data.key?(key)
        end
        ContentValidation.validate_highlights(data["highlights"], file) if data.key?("highlights")
      rescue ContentValidation::Error => e
        raise Jekyll::Errors::FatalException, e.message
      end
    end
  end
end
