$(document).on 'page:change', ->
  $('div.delivery-address-option').click (event) ->
    $hiddenField = $('#checkout_selected_address')[0]
    $clickedElement = $(event.target)
    currentValue = $hiddenField.value
    selectedValue = $clickedElement.attr('data')

    if selectedValue == undefined
      $clickedElement = $clickedElement.parent('[data]')
      selectedValue = $clickedElement.attr('data')

    # If toggling out
    if currentValue == selectedValue
      $hiddenField.value = ''
      $("[data='" + selectedValue + "']").css('border', '1px solid #EBEBEB')
    else
      $hiddenField.value = selectedValue
      $("[data='" + selectedValue + "']").css('border', '3px solid #EF912D')
      if currentValue != ''
        $("[data='" + currentValue + "']").css('border', '1px solid #EBEBEB')

  $('.add-delivery-address-link').click (event) ->
    $this = $('.add-new-delivery-address')

    $('#addNewAddress').css('top', $this.position().top)
    $('#addNewAddress').css('left', $this.position().left + 25)
    $('#addNewAddress').css('width', $this.width() + 40)
    $('#addNewAddress').fadeIn()

  $('div#addNewAddress .cancel').click ->
    $('#addNewAddress').fadeOut()

  $('#new_delivery_address').on("ajax:success", (e, data, status, xhr) ->
      console.log('success')
      $('#addNewAddress').fadeOut()
    ).on "ajax:error", (e, data, status, xhr) ->
      console.log('fail')