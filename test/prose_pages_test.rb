require_relative "test_helper"

class ProsePagesTest < Minitest::Test
  def test_biography_content
    text = site_html("/biography/").at_css("main").text
    %w[Provengo Weizmann HUMIES].each { |w| assert_includes text, w }
  end

  def test_grants_list
    doc = site_html("/grants-awards/")
    assert_equal 6, doc.css("main > ul > li, main > ol > li").size
    text = doc.at_css("main").text
    assert_includes text, "ISTRC"
    assert_includes text, "Bostrom"
  end
end
