require_relative "test_helper"

class BehavioralProgrammingTest < Minitest::Test
  PATH = "/research/behavioral-programming/"

  COBP = "Context-Oriented Behavioral Programming"
  LIVENESS_JOURNAL = "Adding liveness to behavioral programming: theory, implementation, and user study"

  # Papers listed at the end of each topic section, newest first.
  TOPIC_PAPERS = {
    "semantics" => [
      LIVENESS_JOURNAL,
      "Keeping Behavioral Programs Alive: Specifying and Executing Liveness Requirements",
      "What Petri Nets Oblige us to Say Comparing Approaches for Behavior Composition",
      COBP
    ],
    "context" => [
      COBP,
      "A Context-Based Behavioral Language for IoT",
      "Towards Integration of Context-Based and Scenario-Based Development"
    ],
    "ml" => [
      LIVENESS_JOURNAL,
      "Categorizing Methods for Integrating Machine Learning with Executable Specifications",
      "Enhancing Deep Reinforcement Learning with Scenario-Based Modeling",
      "Scenario-assisted Deep Reinforcement Learning",
      "Towards Combining Deep Learning, Verification, and Scenario-Based Programming",
      "Using Behavioral Programming with Solver, Context, and Deep Reinforcement Learning for Playing a Simplified RoboCup-Type Game"
    ],
    "generation" => [
      "Boosting LLM-Based Software Generation by Aligning Code with Requirements",
      "From Requirements to Source Code: Evolution of Behavioral Programs"
    ],
    "testing" => [
      "Generalized Coverage Criteria for Combinatorial Sequence Testing",
      "Provengo: A Tool Suite for Scenario Driven Model-Based Testing"
    ]
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

  def test_papers_have_unique_ids
    ids = doc.css(".pub-list > li.pub").map { |li| li["id"] }
    assert_equal 17, ids.size
    assert_equal ids.uniq, ids
  end

  def test_every_in_page_link_has_a_target
    links = doc.css("main a[href^='#']").map { |a| a["href"] }
    assert_operator links.size, :>=, 20
    links.each { |href| refute_nil doc.at_css("[id='#{href.delete_prefix('#')}']"), "#{href} has no target" }
  end

  def test_every_paper_is_linked_from_the_text
    linked = doc.css("main a[href^='#']").map { |a| a["href"].delete_prefix("#") }
    doc.css(".pub-list > li.pub").each do |li|
      key = li["id"].split("-", 2).last
      assert linked.any? { |l| l.end_with?("-#{key}") }, "nothing links to #{key}"
    end
  end

  def test_each_topic_title_has_a_back_to_top_link
    TOPIC_PAPERS.each_key do |id|
      link = doc.at_css("h2##{id} a.to-top")
      refute_nil link, "##{id} has no back-to-top link"
      assert_equal "#main", link["href"]
    end
  end

  def test_infographic_boxes_link_to_topics
    svg = doc.at_css(".evo-loop svg")
    assert_equal "img", svg["role"]
    assert_equal %w[#semantics #context #ml #generation #testing], svg.css("a").map { |a| a["href"] }
  end

  def test_research_page_links_here
    research = site_html("/research/")
    assert_includes research.css(".research-feature h2 a").map { |a| a["href"] }, PATH
  end

  def test_breadcrumb_links_back_to_research
    assert_equal "/research/", doc.at_css(".breadcrumb a")["href"]
  end
end
