require 'rouge'
require 'rouge/plugins/redcarpet'

class CodeHTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet

  def initialize(extensions = {})
    super extensions.merge(link_attributes: { target: "_blank" })
  end
end
class HTMLwithCodeRay < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div(:tab_width=>2)
    end
end   
