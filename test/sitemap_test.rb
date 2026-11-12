require "test_helper"

class SitemapTest < Minitest::Test
  SITE_URL = "https://achiya.elyasaf.net"
  PAGES = %w[/ /biography/ /grants-awards/ /lab/ /publications/ /research/ /research/dl-operators/].freeze

  def sitemap_urls(dir)
    doc = Nokogiri::XML(File.read(File.join(ROOT, dir, "sitemap.xml"), encoding: "UTF-8"))
    doc.remove_namespaces!
    doc.css("url > loc").map { |loc| loc.text.strip }
  end

  def test_sitemap_lists_every_page_once
    assert_equal PAGES.map { |p| SITE_URL + p }, sitemap_urls("_site")
  end

  def test_sitemap_is_valid_xml_with_declaration_first
    xml = File.read(File.join(SITE, "sitemap.xml"), encoding: "UTF-8")
    assert xml.start_with?('<?xml version="1.0"'), "XML declaration must be the first bytes"
    assert_empty Nokogiri::XML(xml).errors
  end

  def test_sitemap_respects_baseurl
    sitemap_urls("_site_base").each do |u|
      assert u.start_with?("#{SITE_URL}/homepage/"), "#{u} lacks /homepage/ prefix"
    end
  end

  def test_robots_points_to_sitemap
    robots = File.read(File.join(SITE, "robots.txt"), encoding: "UTF-8")
    assert_includes robots, "Sitemap: #{SITE_URL}/sitemap.xml"
  end
end
