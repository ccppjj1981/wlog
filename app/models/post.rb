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
end
