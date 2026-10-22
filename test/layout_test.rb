require "test_helper"

class LayoutTest < Minitest::Test
  def test_nav_order
    texts = site_html("/").css("nav a").map { |a| a.text.strip }
    assert_equal ["Home", "Biography", "Research", "Lab", "Publications", "Grants & Awards"], texts
  end

  def test_footer
    assert_includes site_html("/").at_css("footer").text, "© Achiya Elyasaf since 2019"
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
