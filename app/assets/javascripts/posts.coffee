# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).on 'turbolinks:load', ->
    post_id = $('#show-markdown').attr('value')
    unless post_id == undefined
      $.post('/posts/convert_markdown', {post_id: post_id}, (data) ->
          $('#show-markdown').html(data)
      )
