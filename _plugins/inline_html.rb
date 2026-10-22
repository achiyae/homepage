require "jekyll"

# Liquid filter `inline_html`: makes BibTeX-derived text safe for HTML output.
# The bibtex filters (latex, smallcaps, superscript) emit a few inline tags, so
# those are kept (without attributes, except small-caps styling); every other
# `<`, `>` and bare `&` is escaped. Existing entities are left alone, so text is
# never double-escaped.
module InlineHtml
  TAG = %r{<(/?)(span|sup|sub|em|i|b|small)((?:\s[^<>]*)?)>}i
  TOKEN = Regexp.union(TAG, /&(?!#?\w+;)/, /[<>]/)
  SMALL_CAPS = /style\s*=\s*["']font-variant:\s*small-caps;?["']/i

  module_function

  def inline_html(input)
    input.to_s.gsub(TOKEN) do
      m = Regexp.last_match
      if m[2]
        name = m[2].downcase
        attrs = name == "span" && m[1].empty? && m[3].match?(SMALL_CAPS) ? ' style="font-variant: small-caps;"' : ""
        "<#{m[1]}#{name}#{attrs}>"
      else
        { "&" => "&amp;", "<" => "&lt;", ">" => "&gt;" }.fetch(m[0])
      end
    end
  end
end

Liquid::Template.register_filter(InlineHtml)
