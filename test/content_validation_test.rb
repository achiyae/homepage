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
end
