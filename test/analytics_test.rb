require "test_helper"

class AnalyticsTest < Minitest::Test
  ID = "G-B9KP3X378E"

  # Renders an include with a given measurement ID and Jekyll environment.
  def render(environment:, id: ID, include: "analytics.html")
    config = test_site.config
    original = config["google_analytics"]
    config["google_analytics"] = id
    render_include(include, "jekyll" => { "environment" => environment })
  ensure
    config["google_analytics"] = original
  end

  def test_consent_defaults_to_denied_before_config
    html = render(environment: "production")
    default = html.index("gtag('consent', 'default'")
    assert default, "consent default missing"
    assert_operator default, :<, html.index("gtag('config'")
    assert_operator default, :<, html.index("googletagmanager.com/gtag/js")
    %w[ad_storage ad_user_data ad_personalization].each do |key|
      assert_includes html, "#{key}: 'denied'"
    end
    assert_includes html, "analytics_storage: analyticsConsent === 'granted' ? 'granted' : 'denied'"
  end

  def test_production_banner_starts_hidden_with_both_choices
    banner = Nokogiri::HTML(render(environment: "production", include: "consent-banner.html")).at_css("#consent-banner")
    assert banner, "banner missing"
    assert banner.key?("hidden"), "banner must start hidden until the script checks for a stored choice"
    assert_equal %w[denied granted], banner.css("button[data-consent]").map { |b| b["data-consent"] }.sort
  end

  def test_production_footer_has_cookie_settings
    footer = Nokogiri::HTML(render(environment: "production", include: "footer.html"))
    assert footer.at_css("footer button[data-consent-open]"), "cookie settings button missing"
  end

  def test_no_banner_or_settings_outside_production
    assert_empty render(environment: "development", include: "consent-banner.html").strip
    refute_includes render(environment: "development", include: "footer.html"), "data-consent-open"
    refute site_html("/").at_css("#consent-banner"), "test build must not show the banner"
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
