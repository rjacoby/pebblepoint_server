$(document).on 'click', '.ppt-button', (evt) ->
  path = $(@).data('url')
  console.log(path)
  $.post path, (data) ->
    # $('body').append "Successfully got the page."
    console.log("Navigated!")
