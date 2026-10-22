require "minitest/autorun"
require "nokogiri"
require "jekyll"
require "tmpdir"

ROOT = File.expand_path("..", __dir__)
SITE = File.expand_path("../_site", __dir__)

# Parsed HTML of a built page, e.g. site_html("/") or site_html("/lab/").
def site_html(path)
  file = path == "/" ? "index.html" : File.join(path.delete_prefix("/"), "index.html")
  Nokogiri::HTML(File.read(File.join(SITE, file), encoding: "UTF-8"))
end

def test_site
  $test_site ||= begin
    config = Jekyll.configuration(
      "source" => ROOT, "destination" => Dir.mktmpdir("jekyll-test"), "quiet" => true
    )
    Jekyll::Site.new(config).tap { |s| s.reset; s.read }
  end
end

# Renders an include in the context of the real site; vars become Liquid variables.
def render_include(name, vars = {})
  site = test_site
  args = vars.keys.map { |k| "#{k}=#{k}" }.join(" ")
  template = site.liquid_renderer.file("render_include/#{name}/#{args}").parse("{% include #{name} #{args} %}")
  payload = site.site_payload.merge(vars.transform_keys(&:to_s))
  template.render!(payload, registers: { site: site, page: { "url" => "/" } })
end
