require_relative "test_helper"
require_relative "../_plugins/inline_html"

class EscapingTest < Minitest::Test
  def member(over = {})
    { "name" => "Eve", "role" => "MSc" }.merge(over)
  end

  def card(m) = Nokogiri::HTML(render_include("member-card.html", "m" => m))

  def test_member_name_is_text
    doc = card(member("name" => 'Eve "<b>X</b>" Doe', "photo" => "/a.jpg", "email" => 'a@b.c', "linkedin" => "https://x/y"))
    assert_empty doc.css("b")
    assert_equal 'Eve "<b>X</b>" Doe', doc.at_css("img")["alt"]
    assert_equal 'Eve "<b>X</b>" Doe', doc.at_css("h3").text
    assert_equal 'Eve "<b>X</b>" Doe on LinkedIn', doc.at_css("a[href^='https://x']")["aria-label"]
  end

  def test_member_hrefs_are_escaped
    doc = card(member("website" => 'https://x.org/?a=1&b="2"', "github" => 'https://g/"><i>'))
    assert_equal 'https://x.org/?a=1&b="2"', doc.at_css("a[aria-label$='website']")["href"]
    assert_empty doc.css("i")
  end

  def test_email_without_at_has_no_mailto
    doc = card(member("email" => "not-an-email"))
    assert_empty doc.css("a[href^='mailto:']")
  end

  def test_email_with_at_still_linked
    doc = card(member("email" => "eve@uni.edu"))
    assert_equal "mailto:eve@uni.edu", doc.at_css("a[href^='mailto:']")["href"]
  end

  def test_news_title_is_text_and_link_roundtrips
    item = { "date" => Date.new(2025, 1, 1), "title" => "New <i>paper</i>", "link" => 'https://x.org/?a=1&b="2"' }
    doc = Nokogiri::HTML(render_include("news-item.html", "item" => item))
    assert_empty doc.css("i")
    assert_equal "New <i>paper</i>", doc.at_css("a").text
    assert_equal item["link"], doc.at_css("a")["href"]
  end

  def test_inline_html_escapes_once
    f = InlineHtml
    assert_equal "R&amp;D", f.inline_html("R&D")
    assert_equal "R&amp;D", f.inline_html("R&amp;D")
  end

  def test_inline_html_keeps_formatting_drops_other_tags
    out = InlineHtml.inline_html('A <sup>2</sup> <span style="font-variant: small-caps;">x</span> <script>alert(1)</script>')
    assert_includes out, "<sup>2</sup>"
    assert_includes out, "small-caps"
    refute_includes out, "<script"
  end

  def test_publication_text_has_only_inline_formatting
    page = site_html("/publications/")
    page.css(".pub-title, .pub-venue").each do |node|
      bad = node.element_children.reject { |c| %w[span sup sub em i b small].include?(c.name) }
      assert_empty bad, node.to_html
    end
  end

  def test_publication_ampersand_single_escaped_in_source
    html = File.read(File.join(SITE, "publications", "index.html"), encoding: "UTF-8")
    assert_includes html, "Autonomous &amp; Robotic Systems"
    refute_includes html, "&amp;amp;"
  end
end
