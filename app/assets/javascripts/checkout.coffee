# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'change', '.pm-checkbox', ->
  $('.pm-checkbox').not(this).prop('checked', false)

$(document).on 'click', '.del-address', ->
  $('#delivery_address').val($(this).attr('del-id'))

  # Clean up
  $('.del-address').css({'border': ''})
  $(".glyphicon-check").remove()

  # Highlight selected Delivery Address
  $(this).css({'border': '2px solid rgba(184, 233, 134, 0.8)'})
  checkIcon = $("<span>").addClass("greencheck pull-right")
  $(this).find('.del-name').append(checkIcon);


$(document).on 'page:change', ->
  $('.schedule-picker').schedulePicker()