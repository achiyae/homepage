require "test_helper"

class HomeTest < Minitest::Test
  def items(n)
    (1..n).map { |i| { "date" => Date.new(2025, 1, 1) << i, "title" => "Item #{i}" } }
  end

  def test_news_shows_8_then_more
    doc = Nokogiri::HTML(render_include("news.html", "items" => items(10)))
    assert_equal 8, doc.css("li.news-item").reject { |li| li.ancestors("details").any? }.size
    assert_equal 2, doc.css("details.news-more li.news-item").size
  end

  def test_no_more_when_few
    doc = Nokogiri::HTML(render_include("news.html", "items" => items(3)))
    assert_empty doc.css("details")
    assert_equal 3, doc.css("li.news-item").size
  end

  def test_news_item_without_link
    doc = Nokogiri::HTML(render_include("news.html", "items" => items(1)))
    assert_empty doc.css("li.news-item a")
    assert_includes doc.css("li.news-item").text, "Item 1"
    assert_match(/\A\d{4}-\d\d-\d\d\z/, doc.at_css("time")["datetime"])
  end

  def test_home_contact
    text = site_html("/").text
    ["achiya AT bgu.ac.il", "Building 96, room 224"].each { |s| assert_includes text, s }
  end

  def test_recruiting_hidden_when_flag_off
    refute site_html("/").at_css(".recruiting")
    refute_includes site_html("/lab/").text, "Interested in joining"
  end

  def test_recruiting_include_renders_notice
    doc = Nokogiri::HTML(render_include("recruiting.html"))
    assert_includes doc.at_css("p.recruiting").text, "actively recruiting"
  end

  def test_no_faculty_page_link
    refute site_html("/").css("a").any? { |a| a["href"].to_s.include?("in.bgu.ac.il") }
  end
end
