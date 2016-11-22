require 'markdown'
class Post < ApplicationRecord
  has_many :comments ,dependent: :destroy
  validates :title, presence: true,
                   length: { minimum: 5 }
  validates :text, :presence=>true, :length => { :minimum=> 30 }
  def labels_content( need_blank=false )
    content = self.labels.collect { |label| label.name }.join(", ")
    content = I18n.t('none') if content.blank? and !need_blank
    content
  end
  def content_html
    self.class.render_html(self.text)
  end
  #提取高亮代码
  def self.hcode(content)
    return unless content.match(/<code\s+(\w+)>/)
    code = content.clone
    if reg = code.match(/<code\s+(\w+)>/)
      start = code.index(/<code\s+\w+>/)
      last = code.index(/<\/code>/)
      code = code.slice!(start+11..last-1)
      code = CodeRay.scan(code, reg[1]).div(:tab_width=>2)
    end
  end
  #把高亮代码替换到html
  def self.replace_code(content, code)
    if content.match(/<code\s+(\w+)>\n?(.*\n)*\n?<\/code>/)
      content.gsub(/<code\s+(\w+)>\n?(.*\n)*\n?<\/code>/,code)
    elsif content.match(/<code\s+(\w+)>.*<\/code>/)
      content.gsub(/<code\s+(\w+)>.*<\/code>/,code)
    end
  end
  def self.render_html(content)
   #rd = CodeHTML.new
   code = hcode content
   rd = HTMLwithCodeRay.new
   md = Redcarpet::Markdown.new(rd, autolink: true, fenced_code_blocks: true)
   content = md.render(content)
   content = replace_code(content,code)  unless code.nil?
   content.html_safe
  end
  # truncate content for home page display
  def sub_content
    HTML_Truncator.truncate(content_html, 300, length_in_chars: true)
  end
  # truncate content for meta description display
  def meta_content
    html = HTML_Truncator.truncate(content_html, 100, :length_in_chars => true, ellipsis: '')
    # Easily get text for Nokogiri
    html = '<div>' + html + '</div>'
    Nokogiri.parse(html).text()
  end
end
