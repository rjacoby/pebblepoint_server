foo = ''
$(document).on 'click', '.ppt-button', (evt) ->
  path = $(@).data('url')
  $.post path, (data) ->
    console.log(data)
    if data.success
      flash = $('#flash')
      flash.html(data.pageNumber)
      flash.slideDown()
