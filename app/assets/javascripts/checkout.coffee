# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->

  # Register event handler to handle callback
  # when item quantity is updated from the popover menu
  updatePurchaseOrderCallbacks.add (data) ->
    if data.qty > 0
      $('#tr_' + data.sku + '> td:nth-child(5)').html(data.qty)
      $('#tr_' + data.sku + '> td:nth-child(6)').html(data.subtotal)
    else
      $('#tr_' + data.sku).remove()

  # Create a calendar which the user will use to select the delivery date
  $('.schedule-picker').fullCalendar({
      theme: true,
      fixedWeekCount: false,
      header: {
        left: 'prev, next, today',
        center: 'title',
        right: ''
      },
      dayClick: (date, jsEvent, view) ->
        currentDate = moment(moment().format("YYYY-MM-DD"))
        selectedDate = moment(date.format())

        if selectedDate.isBefore(currentDate)
          swal("Invalid Date", "Date cannot be before the present date", "error")
          return

        if selectedDate.isAfter(moment().add(14, 'days'))
          swal("Invalid Date","We are not able to schedule beyond 14 days from now","error")
          return

        $.ajax
          url: '/delivery-time/' + currentDate.format("YYYY-MM-DD")
          type: 'get',
          success: (data, status, response) ->
            console.log(data)
            return
          error: (xhr) ->
            swal("Invalid Date", JSON.parse(xhr.responseText).error, "error")
            return
    })

  $('.iRadio').iCheck({
    checkboxClass: 'icheckbox_square-blue',
    radioClass: 'iradio_square-blue',
    increaseArea: '20%',
  })

  $('.iRadio'). on 'ifChecked', (event) ->
    console.log($(this))
    #$(this).addClass('checked')

  $('.iRadio'). on 'ifUnchecked', (event) ->
    console.log($(this))
    #$(this).removeClass('checked')

  $('.iRadio').on 'click', ->
    console.log('Clicked')
