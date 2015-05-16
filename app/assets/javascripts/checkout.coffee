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
  $(".greencheck").remove()

  # Highlight selected Delivery Address
  $(this).css({'border': '2px solid rgba(184, 233, 134, 0.8)'})
  checkIcon = $("<span>").addClass("greencheck pull-right")
  $(this).find('.del-name').append(checkIcon);

$(document).on 'click', '.selectable-cell', ->
  # Clear any previously highlighted cell
  $('.selectable-cell').css({"background-color": ""})

  # Highlight selected cell
  $(this).css({"background-color": "rgba(184, 233, 134, 0.8)"})

  # Get selected row index
  # The row index starts at index 0 and the selectable cells starts at row 2
  # We apply the formula: n * 8 - [(n - 1) * 6] to get the schedule delivery range
  selectedIndex = $('.schedule-table tr').index($(this).parent()) - 1
  timeRange = (selectedIndex * 8) - ((selectedIndex - 1) * 6)
  $('#delivery_schedule').val($(this).attr("date-time") + " "+ "#{timeRange}:00 - #{timeRange + 2}:00")


$(document).on 'page:change', ->
  $('.schedule-picker').schedulePicker()