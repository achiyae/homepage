require "test_helper"
require_relative "../_plugins/content_validation"

class ContentValidationTest < Minitest::Test
  CV = ContentValidation

  def test_mixed_date_forms_sort_desc
    items = [{ "date" => Date.new(2023, 1, 1), "title" => "a" }, { "date" => "2025-03-01", "title" => "b" }]
    assert_equal %w[b a], CV.normalize_news(items, "index.md").map { |i| i["title"] }
    assert_kind_of Date, CV.normalize_news(items, "index.md").first["date"]
  end

  def test_bad_date_raises
    err = assert_raises(CV::Error) { CV.normalize_news([{ "date" => "March 2025", "title" => "a" }], "index.md") }
    assert_match(/index\.md.*item 1.*date/, err.message)
  end

  def test_missing_title_raises
    err = assert_raises(CV::Error) { CV.normalize_news([{ "date" => "2025-03-01" }], "index.md") }
    assert_match(/index\.md.*item 1.*title/, err.message)
  end

  def test_people_missing_role_raises
    err = assert_raises(CV::Error) { CV.validate_people([{ "name" => "X" }], "lab.md", "members") }
    assert_match(/lab\.md.*members.*item 1.*role/, err.message)
  end

  def test_highlight_bad_kind_raises
    item = { "title" => "t", "summary" => "s", "link" => "/x", "kind" => "video" }
    err = assert_raises(CV::Error) { CV.validate_highlights([item], "research.md") }
    assert_match(/research\.md.*item 1.*kind/, err.message)
  end

  def test_equal_dates_keep_authored_order
    items = %w[a b c d].map { |t| { "date" => "2023-01-01", "title" => t } }
    items.insert(2, { "date" => "2024-01-01", "title" => "new" })
    assert_equal %w[new a b c d], CV.normalize_news(items, "index.md").map { |i| i["title"] }
  end

  FakePage = Struct.new(:data, :path)
  FakeSite = Struct.new(:pages, :config, :source, :data)

  def generate(*pages)
    CV::Generator.new({}).generate(FakeSite.new(pages, {}, Dir.mktmpdir("src"), {}))
  end

  def test_generator_replaces_news_with_normalized_sorted_list
    page = FakePage.new({ "news" => [{ "date" => Date.new(2023, 1, 1), "title" => "a" },
                                     { "date" => "2025-03-01", "title" => "b" }] }, "index.md")
    generate(page)
    assert_equal %w[b a], page.data["news"].map { |i| i["title"] }
    assert(page.data["news"].all? { |i| i["date"].instance_of?(Date) })
  end

  def test_generator_raises_fatal_exception_for_invalid_members
    page = FakePage.new({ "members" => [{ "name" => "X" }] }, "lab.md")
    err = assert_raises(Jekyll::Errors::FatalException) { generate(page) }
    assert_match(/lab\.md.*item 1.*role/, err.message)
  end

  def bib_file(text)
    f = File.join(Dir.mktmpdir("bib"), "t.bib")
    File.write(f, text)
    f
  end

  def test_bibliography_missing_year_names_key
    err = assert_raises(CV::Error) { CV.validate_bibliography(bib_file("@article{Foo2020,\n title={T}\n}\n")) }
    assert_match(/entry Foo2020 needs a 4-digit year/, err.message)
  end

  def test_bibliography_bad_year_raises
    assert_raises(CV::Error) { CV.validate_bibliography(bib_file("@article{Foo,\n year={20}\n}\n")) }
  end

  def test_bibliography_years_newest_first
    f = bib_file("@article{A,\n year={2019}\n}\n@article{B,\n year={2027}\n}\n@article{C,\n year={2019}\n}\n")
    assert_equal %w[2027 2019], CV.validate_bibliography(f)
  end
end
