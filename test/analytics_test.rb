require "test_helper"

class AnalyticsTest < Minitest::Test
  ID = "G-B9KP3X378E"

  # Renders the include with a given measurement ID and Jekyll environment.
  def render(environment:, id: ID)
    config = test_site.config
    original = config["google_analytics"]
    config["google_analytics"] = id
    render_include("analytics.html", "jekyll" => { "environment" => environment })
  ensure
    config["google_analytics"] = original
  end

  def test_site_is_configured_with_measurement_id
    assert_equal ID, test_site.config["google_analytics"]
  end

  def test_production_build_loads_gtag
    html = render(environment: "production")
    assert_includes html, "https://www.googletagmanager.com/gtag/js?id=#{ID}"
    assert_includes html, %(gtag('config', "#{ID}"))
  end

  def test_development_build_omits_gtag
    assert_empty render(environment: "development").strip
  end

  def test_missing_id_omits_gtag
    assert_empty render(environment: "production", id: nil).strip
  end

  def test_test_builds_have_no_tracking
    refute_includes File.read(File.join(SITE, "index.html")), "googletagmanager"
  end
end
