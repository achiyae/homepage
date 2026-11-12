require_relative "test_helper"

class DlOperatorsTest < Minitest::Test
  PATH = "/research/dl-operators/"

  GPTP = "Deep learning-based operators for evolutionary algorithms"

  # Papers listed at the end of each topic section, newest first.
  TOPIC_PAPERS = {
    "crossover" => [
      "Energy-Efficient AI-Assisted Evolution: A Case Study on Minimizing the Power Consumption of Deep Neural Crossover",
      GPTP,
      "Deep Neural Crossover: A Multi-Parent Operator That Leverages Gene Correlations"
    ],
    "mutation" => [
      "BERT Mutation for Genetic Algorithms: A Deep Transformer Operator",
      "BERT Mutation: Deep Transformer Model for Masked Uniform Mutation in Genetic Programming",
      GPTP
    ],
    "selection" => ["Deep Tournament Selection for Genetic Algorithms"],
    "evaluation" => ["Fitness Approximation Through Machine Learning with Dynamic Adaptation to the Evolutionary State"]
  }.freeze

  def doc
    @doc ||= site_html(PATH)
  end

  # Titles of the paper list that follows the h2 with the given id, up to the next h2.
  def papers_after(id)
    titles = []
    node = doc.at_css("h2##{id}").next_element
    while node && node.name != "h2"
      titles.concat(node.css("li.pub .pub-title").map { |t| t.text.strip })
      node = node.next_element
    end
    titles
  end

  def test_each_topic_ends_with_its_papers
    TOPIC_PAPERS.each { |id, titles| assert_equal titles, papers_after(id), "papers under ##{id}" }
  end

  def test_papers_have_links_and_unique_ids
    pubs = doc.css(".pub-list > li.pub")
    assert_equal 8, pubs.size
    ids = pubs.map { |li| li["id"] }
    assert_equal ids.uniq, ids
    pubs.each { |li| refute_nil li.at_css("a.pub-link"), "#{li['id']} has no link" }
  end

  def test_every_in_page_link_has_a_target
    links = doc.css("main a[href^='#']").map { |a| a["href"] }
    assert_operator links.size, :>=, 15
    links.each { |href| refute_nil doc.at_css("[id='#{href.delete_prefix('#')}']"), "#{href} has no target" }
  end

  def test_every_paper_is_linked_from_the_text
    linked = doc.css("main a[href^='#']").map { |a| a["href"].delete_prefix("#") }
    doc.css(".pub-list > li.pub").each do |li|
      key = li["id"].split("-", 2).last
      assert linked.any? { |l| l.end_with?("-#{key}") }, "nothing links to #{key}"
    end
  end

  def test_infographic_boxes_link_to_topics
    svg = doc.at_css(".evo-loop svg")
    assert_equal "img", svg["role"]
    assert_equal %w[#selection #crossover #mutation #evaluation], svg.css("a").map { |a| a["href"] }
    assert_includes svg.text, "for GP and GAs"
  end

  def test_images_exist_and_have_alt_text
    imgs = doc.css("main img")
    assert_equal 7, imgs.size
    imgs.each do |img|
      refute_empty img["alt"].to_s.strip, "#{img['src']} lacks alt text"
      assert File.exist?(File.join(SITE, img["src"].delete_prefix("/"))), "#{img['src']} is missing"
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
