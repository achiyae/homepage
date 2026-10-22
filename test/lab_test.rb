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
    assert_equal "bitme AT post.bgu.ac.il", a.text
    assert_equal "mailto:bitme@post.bgu.ac.il", a["href"]
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
