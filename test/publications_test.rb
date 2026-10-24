require_relative "test_helper"

class PublicationsTest < Minitest::Test
  BIB = File.read(File.join(ROOT, "_bibliography", "publications.bib"), encoding: "UTF-8")
  GP_RUSH = "GP-Rush: Using Genetic Programming to Evolve Solvers for the Rush Hour Puzzle"

  def page = (@page ||= site_html("/publications/"))
  def pubs = page.css("#pub-list li.pub")
  def gp_rush = pubs.find { |li| li.at_css(".pub-title").text.strip.start_with?("GP-Rush") }

  def test_entry_count
    expected = BIB.scan(/^@(\w+)\{/).flatten.reject { |t| %w[comment string preamble].include?(t.downcase) }.size
    assert_equal expected, pubs.size
  end

  def test_rendered_years_match_bib_years
    bib_years = BIB.scan(/^\s*year\s*=\s*[{"]?(\d{4})/).flatten.uniq.sort
    rendered = page.css("#pub-list section.pub-year").map { |s| s["data-year"] }.sort
    assert_equal bib_years, rendered
  end

  def test_years_descending
    years = page.css("#pub-list section.pub-year").map { |s| s["data-year"].to_i }
    refute_empty years
    assert_equal years.sort.reverse.uniq, years
  end

  def test_title_braces_stripped
    title = gp_rush.at_css(".pub-title").text.strip
    assert_equal GP_RUSH, title
    refute_match(/[{}]/, title)
  end

  # The brief assumed GP-Rush has no url, but its BibTeX has both; url must win over doi.
  def test_url_preferred_over_doi
    assert_equal "http://portal.acm.org/citation.cfm?doid=1569901.1570032", gp_rush.at_css("a.pub-link")["href"]
  end

  def test_doi_fallback
    li = pubs.find do |p|
      raw = p.at_css("details.pub-bib pre").text
      raw =~ /^\s*doi\s*=\s*\{10\.1609\/socs\.v2i1\.18212\}/ && raw !~ /^\s*url\s*=/i
    end
    refute_nil li, "expected an entry with a doi and no url"
    assert_equal "https://doi.org/10.1609/socs.v2i1.18212", li.at_css("a.pub-link")["href"]
  end

  def test_no_link_when_neither
    pubs.each do |li|
      raw = li.at_css("details.pub-bib pre").text
      next if raw =~ /^\s*(url|doi)\s*=/i
      assert_nil li.at_css("a.pub-link"), "unexpected link on #{li.at_css('.pub-title').text}"
    end
  end

  def test_links_open_in_new_tab
    links = pubs.map { |li| li.at_css("a.pub-link") }.compact
    refute_empty links
    links.each do |a|
      assert_equal "_blank", a["target"]
      assert_equal "noopener noreferrer", a["rel"]
    end
  end

  def test_topics_limited_to_allowed_set
    allowed = ["Artificial Intelligence", "Behavioral Programming", "Evolutionary Computation", "Machine Learning", "Testing", "Software Engineering"]
    pubs.each do |li|
      li["data-topics"].to_s.split(",").map(&:strip).each do |t|
        assert_includes allowed, t, "unexpected topic on #{li.at_css('.pub-title').text}"
      end
    end
  end

  def test_bp_and_testing_are_software_engineering
    pubs.each do |li|
      topics = li["data-topics"].to_s.split(",").map(&:strip)
      next unless topics.include?("Behavioral Programming") || topics.include?("Testing")
      assert_includes topics, "Software Engineering", li.at_css(".pub-title").text
    end
  end

  def test_ec_and_ml_are_ai
    pubs.each do |li|
      topics = li["data-topics"].to_s.split(",").map(&:strip)
      next unless topics.include?("Evolutionary Computation") || topics.include?("Machine Learning")
      assert_includes topics, "Artificial Intelligence", li.at_css(".pub-title").text
    end
  end

  def test_first_author_attr
    assert_equal "Ami Hauptman", gp_rush["data-first-author"]
    assert_equal "Ami Hauptman|Achiya Elyasaf|Moshe Sipper|Assaf Karmon", gp_rush["data-authors"]
    assert_equal "Artificial Intelligence, Evolutionary Computation", gp_rush["data-topics"]
  end

  def test_copyright_notice
    assert_includes page.text, "Copyright and all rights therein are maintained by the authors"
    assert page.at_css("#pub-filters[hidden]")
    notice = page.at_css("p.pub-copyright")
    refute_nil notice
    assert notice.matches?("#pub-list ~ p"), "copyright notice should follow the publication list"
  end

  def test_abstract_toggle
    abstract = gp_rush.at_css("details.pub-abstract")
    refute_nil abstract
    assert_equal "[abstract]", abstract.at_css("summary").text
    assert_match(/IDA\* search/, abstract.at_css("p").text)
    refute_match(/abstract\s*=/, gp_rush.at_css("details.pub-bib pre").text)
  end
end
