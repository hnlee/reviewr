module ApplicationHelper
  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div
    end
  end

  def markdown(text)
    coderayified = CodeRayify.new(:filter_html => true, 
                                  :hard_wrap => true, 
                                  link_attributes: { rel: "nofollow", target: "_blank" })
    extensions = {
      fenced_code_blocks: true,
      autolink: true,
      highlight: true, 
      superscript: true,
      strikethrough: true,
      underline: true,
      disable_indented_code_blocks: true
    }

    markdown = Redcarpet::Markdown.new(coderayified, extensions)

    markdown.render(text).html_safe
  end

end