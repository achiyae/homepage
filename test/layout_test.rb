require "test_helper"

class LayoutTest < Minitest::Test
  def test_nav_order
    texts = site_html("/").css("nav a").map { |a| a.text.strip }
    assert_equal ["Home", "Biography", "Research", "Lab", "Publications", "Grants & Awards"], texts
  end

  def test_footer
    assert_includes site_html("/").at_css("footer").text, "© Achiya Elyasaf since 2019"
  end

  def test_footer_faculty_logo
    %w[/ /lab/ /publications/].each do |path|
      a = site_html(path).at_css("footer a.faculty-logo")
      assert a, "faculty logo missing on #{path}"
      assert_equal "https://www.bgu.ac.il/en/u/faculties/computer-and-information-science/", a["href"]
      assert_equal "_blank", a["target"]
      assert_includes a["rel"].to_s.split, "noopener"
      img = a.at_css("img")
      assert_match %r{/assets/img/faculty-logo\.png\z}, img["src"]
      assert_includes img["alt"], "Stein Faculty of Computer and Information Science"
    end
  end

  def test_social_links
    hrefs = site_html("/").css("a").map { |a| a["href"] }
    [
      "https://x.com/AElyasaf",
      "https://www.linkedin.com/in/achiyae/",
      "https://orcid.org/0000-0002-4009-5353",
      "https://scholar.google.co.il/citations?hl=en&user=EBx5rKoAAAAJ",
      "https://dblp.org/pid/87/7184.html"
    ].each { |url| assert_includes hrefs, url }
  end

  def test_social_links_open_in_new_tab
    links = site_html("/").css("header .social a")
    refute_empty links
    links.each do |a|
      assert_equal "_blank", a["target"]
      assert_includes a["rel"].to_s.split, "noopener"
    end
  end

  def test_baseurl_prefix
    doc = Nokogiri::HTML(File.read(File.expand_path("../_site_base/index.html", __dir__), encoding: "UTF-8"))
    urls = doc.css('a[href^="/"]').map { |e| e["href"] } +
           doc.css('link[href^="/"]').map { |e| e["href"] } +
           doc.css('script[src^="/"]').map { |e| e["src"] } +
           doc.css('img[src^="/"]').map { |e| e["src"] }
    refute_empty urls
    urls.each { |u| assert u.start_with?("/homepage/"), "#{u} lacks /homepage/ prefix" }
  end
end
