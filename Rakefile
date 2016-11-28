# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks
Rails.application.load_tasks
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HTML < Redcarpet::Render::HTML
 include Rouge::Plugins::Redcarpet # yep, that's it.
end

#namespace :highlight do
 desc 'Translate README.md'
 task :render do
   puts 'ok'
   markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, fenced_code_blocks: true)
   readme = File.read("#{Rails.root}/README.md")
   puts markdown.render(readme)
 end
#end
desc "任务1 -- 买菜"
task :purchaseVegetables do
puts "到沃尔玛去买菜。"
end
