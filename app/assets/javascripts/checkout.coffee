# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'change', '.pm-checkbox', ->
  $('.pm-checkbox').not(this).prop('checked', false)

$(document).on 'click', '.del-address', ->
  $('#delivery_address').val($(this).attr('del-id'))
  # clear border first
  $('.del-address').css({'border': ''})
  #highlight the selected delivery address
  $(this).css({'border': '2px solid rgba(184, 233, 134, 0.8)'})