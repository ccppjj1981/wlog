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
  def self.render_html(content)
    rd = CodeHTML.new
    md = Redcarpet::Markdown.new(rd, autolink: true, fenced_code_blocks: true)
    md.render(content)
  end
  def content_html
    self.class.render_html(self.text)
  end
  def self.render_html(content)
   Rails.logger.info("============render_html")
   rd = CodeHTML.new
   md = Redcarpet::Markdown.new(rd, autolink: true, fenced_code_blocks: true)
   md.render(content)
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
