# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

$(document).on 'turbolinks:load', ->
  $('a#upload_photo').click ->
    $('input[type=file]').show().focus().click().hide()
    false

  console.log('==============1')
  $('#tabs').on 'change.zf.tabs', ()->
    console.log('==========select tabs')
    if $('#preview:visible').length > 0
      $('#preview').text('Loading...')
      $.ajax
        url: '/posts/preview'
        type: 'POST'
        data:
          content: $('#content-input').val()
        success: (data)->
          $('#preview').html(data)

  $('a.tag').click (event)->
    event.preventDefault()
   