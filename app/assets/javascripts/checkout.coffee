# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->

  # Register event handler to handle callback
  # when item quantity is updated from the popover menu
  updatePurchaseOrderCallbacks.add (data) ->
    if data.qty > 0
      $('#tr_' + data.sku + '> td:nth-child(5)').html data.qty
      $('#tr_' + data.sku + '> td:nth-child(6)').html data.subtotal
      $('.grand-total').html data.carttotal
    else
      $('#tr_' + data.sku).remove()

  # Create a calendar which the user will use to select the delivery date
  $('.schedule-picker').fullCalendar({
      theme: true,
      fixedWeekCount: false,
      header: {
        left: 'prev, next, today',
        center: '',
        right: 'title'
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
          url: '/delivery-time/' + selectedDate.format("YYYY-MM-DD")
          type: 'get',
          success: (data, status, response) ->

            timeSlots = []
            $.each data.timeslot, (idx, obj) ->
              option = $('<option value="' + obj.starttime + '">' + obj.starttime + ' - ' +  obj.endtime + '</option>')
              timeSlots.push option

            # clean up drop down boxes
            $('#delivery-window .modal-dialog .modal-content .modal-body select').remove()
            $('#delivery-window .modal-dialog .modal-content .modal-body .bootstrap-select').remove()

            # set new drop down box
            $('#delivery-window .modal-body').prepend($('<select name="time-slot" class="selectpicker">').append(timeSlots))

            $('#form_schedule').val selectedDate.format("DD-MM-YYYY")

            # display modal window
            $('#delivery-window').modal 'show'

            $('.selectpicker').selectpicker()
            return
          error: (xhr) ->
            swal("Invalid Date", JSON.parse(xhr.responseText).error, "error")
            return
    })

  $('.iRadio').iCheck
    checkboxClass: 'icheckbox_square-blue',
    radioClass: 'iradio_square-blue',
    increaseArea: '20%',


  format = 'DD-MM-YYYY HH:mm'

  $('.confirm-delivery-time').on 'click', ->
    dateComponent = $('#form_schedule').val()
    timeComponent = $('#delivery-window .modal-body select').find(':selected').val()

    # append the time component to form DD-MM-YYYY HH:mm
    dateComponent += ' ' + timeComponent

    #restore it back to the hidden field
    $('#form_schedule').val(dateComponent)

    # remove temporary events first
    $('.schedule-picker').fullCalendar 'removeEvents', -1

    # set new event
    deliveryDate = moment(dateComponent, format)
    event = new Object()
    event.id = -1
    event.title = 'Delivery'
    event.start = deliveryDate

    $('.schedule-picker').fullCalendar 'renderEvent', event, true

    $('#delivery-window').modal 'hide'
    return

  if $('#form_schedule') != ""
    date = $('#form_schedule').val()
    deliveryDate = moment(date, format)
    event = new Object()
    event.id = -1
    event.title = 'Delivery'
    event.start = deliveryDate

    $('.schedule-picker').fullCalendar 'renderEvent', event, true
