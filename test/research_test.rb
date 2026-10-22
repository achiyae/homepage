require_relative "test_helper"

class ResearchTest < Minitest::Test
  TITLES = [
    "BERT Mutation: Deep Transformer Model for Masked Uniform Mutation in Genetic Programming",
    "Deep Neural Crossover: A Multi-Parent Operator That Leverages Gene Correlations",
    "Towards Better Interoperability Between Software and AI",
    "What Petri Nets Oblige Us to Say: Comparing Approaches for Behavior Composition",
    "EC-KitY",
    "Context-Oriented Behavioral Programming"
  ].freeze

  def test_research_order
    doc = site_html("/research/")
    assert_equal TITLES, doc.css(".highlight h3").map { |h| h.text.strip }
  end

  def test_talk_badge
    doc = site_html("/research/")
    assert_equal "talk", doc.css(".highlight")[2].at_css(".highlight-kind").text.strip
  end

  def test_card_without_image
    html = Nokogiri::HTML.fragment(
      render_include("highlight-card.html", "h" => { "title" => "T", "summary" => "S", "link" => "https://example.org" })
    )
    assert_nil html.at_css("img")
    assert_nil html.at_css(".highlight-kind")
    assert_equal "T", html.at_css("h3 a").text.strip
  end

  def test_link_is_escaped_in_href
    url = "https://example.org/p?a=1&b=2\"x"
    html = render_include("highlight-card.html", "h" => { "title" => "T", "summary" => "S", "link" => url })
    refute_includes html, "b=2\"x"
    assert_equal url, Nokogiri::HTML.fragment(html).at_css("h3 a")["href"]
  end
end
