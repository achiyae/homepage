require_relative "test_helper"

class ProsePagesTest < Minitest::Test
  def test_biography_content
    text = site_html("/biography/").at_css("main").text
    %w[Provengo Weizmann HUMIES].each { |w| assert_includes text, w }
  end

  def test_grants_list
    doc = site_html("/grants-awards/")
    assert_equal %w[Grants Awards\ and\ fellowships], doc.css("main h2").map { |h| h.text.strip }
    grants, awards = doc.css("main ul.cv-list")
    assert_equal 9, grants.css("> li").size
    assert_equal 7, awards.css("> li").size
    doc.css("ul.cv-list > li").each { |li| assert_match(/\A\d{4}(–\d{4})?\z/, li.at_css(".cv-year").text) }
    text = doc.at_css("main").text
    %w[ISTRC Bostrom HUMIES Provengo].each { |w| assert_includes text, w }
  end
end
