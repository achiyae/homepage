require_relative "test_helper"

class DlOperatorsTest < Minitest::Test
  PATH = "/research/dl-operators/"

  PAPERS = [
    "BERT Mutation for Genetic Algorithms: A Deep Transformer Operator",
    "Deep Tournament Selection for Genetic Algorithms",
    "Energy-Efficient AI-Assisted Evolution: A Case Study on Minimizing the Power Consumption of Deep Neural Crossover",
    "BERT Mutation: Deep Transformer Model for Masked Uniform Mutation in Genetic Programming",
    "Deep learning-based operators for evolutionary algorithms",
    "Deep Neural Crossover: A Multi-Parent Operator That Leverages Gene Correlations",
    "Fitness Approximation Through Machine Learning with Dynamic Adaptation to the Evolutionary State"
  ].freeze

  def doc
    @doc ||= site_html(PATH)
  end

  def test_papers_listed_newest_first
    assert_equal PAPERS, doc.css(".pub-list > li.pub .pub-title").map { |t| t.text.strip }
  end

  def test_papers_have_links
    doc.css(".pub-list > li.pub").each do |li|
      refute_nil li.at_css("a.pub-link"), "#{li.at_css('.pub-title').text.strip} has no link"
    end
  end

  def test_images_exist_and_have_alt_text
    imgs = doc.css("main img")
    assert_equal 5, imgs.size
    imgs.each do |img|
      refute_empty img["alt"].to_s.strip, "#{img['src']} lacks alt text"
      assert File.exist?(File.join(SITE, img["src"].delete_prefix("/"))), "#{img['src']} is missing"
    end
  end

  def test_infographic_is_accessible
    svg = doc.at_css(".evo-loop svg")
    assert_equal "img", svg["role"]
    %w[Deep\ Tournament Deep\ Neural BERT\ Mutation ML\ Fitness].each do |name|
      assert_includes svg.text, name
    end
  end

  def test_research_page_links_here
    research = site_html("/research/")
    assert_equal PATH, research.at_css(".research-feature h2 a")["href"]
    refute_includes research.at_css("main").text, "</a>"
  end

  def test_breadcrumb_links_back_to_research
    assert_equal "/research/", doc.at_css(".breadcrumb a")["href"]
  end
end
