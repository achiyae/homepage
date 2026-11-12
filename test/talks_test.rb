require_relative "test_helper"

class TalksTest < Minitest::Test
  TALKS = {
    "Automatic Code Generation" => "https://www.youtube.com/watch?v=02_Dl6CMtBs",
    "What Petri Nets Oblige Us to Say" => "https://www.youtube.com/watch?v=5COISMtg2P0",
    "Towards Better Interoperability Between Software and AI" => "https://www.youtube.com/watch?v=yD6o_-ZKogs"
  }.freeze

  def doc
    @doc ||= site_html("/talks/")
  end

  def test_one_card_per_talk_newest_first
    links = doc.css(".highlight h3 a").map { |a| [a.text.strip, a["href"]] }.to_h
    assert_equal TALKS, links
  end

  def test_cards_have_thumbnail_kind_and_meta
    doc.css(".highlight").each do |card|
      title = card.at_css("h3").text.strip
      img = card.at_css("img.highlight-image")
      refute_nil img, "#{title} has no thumbnail"
      assert File.exist?(File.join(SITE, img["src"].delete_prefix("/"))), "#{img['src']} is missing"
      refute_nil card.at_css(".highlight-kind"), "#{title} has no kind badge"
      assert_match(/\d+ min/, card.at_css(".highlight-meta").text, "#{title} has no duration")
    end
  end
end
