require_relative "test_helper"

class LabTest < Minitest::Test
  def card(m)
    Nokogiri::HTML.fragment(render_include("member-card.html", "m" => m))
  end

  def test_initials_when_no_photo
    html = card("name" => "Ori Eines", "role" => "M.Sc. student")
    assert_equal "OE", html.at_css(".member-initials").text
    assert_nil html.at_css("img")
    assert_empty html.css(".member-links a")
  end

  def test_email_obfuscated
    html = card("name" => "A B", "role" => "r", "email" => "bitme@post.bgu.ac.il")
    a = html.at_css(".member-links a")
    assert_equal "bitme AT post.bgu.ac.il", a["title"]
    assert_equal "mailto:bitme@post.bgu.ac.il", a["href"]
    assert_nil a["target"], "mailto links stay in the same tab"
  end

  def test_links_are_icons_opening_in_new_tab
    html = card("name" => "A B", "role" => "r", "email" => "a@b.c",
                "linkedin" => "https://www.linkedin.com/in/x", "github" => "https://github.com/x", "website" => "https://x.dev")
    links = html.css(".member-links a")
    assert_equal 4, links.size
    links.each do |a|
      assert a.at_css("svg"), "#{a['href']} should be an icon"
      assert_empty a.text.strip, "#{a['href']} should have no visible text"
      refute_empty a["aria-label"].to_s
    end
    links.reject { |a| a["href"].start_with?("mailto:") }.each do |a|
      assert_equal "_blank", a["target"]
      assert_includes a["rel"].to_s.split, "noopener"
    end
  end

  def test_lab_counts
    doc = site_html("/lab/")
    assert_equal 18, doc.css(".members .member").size
    assert_equal 3, doc.css(".alumni .member").size
  end

  def test_no_bug_typo
    refute_includes File.read(File.join(SITE, "lab/index.html")), "post.bug.ac.il"
  end
end
