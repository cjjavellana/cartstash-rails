$(document).on 'page:change', ->
  onDeliveryAddressSelect = (event) ->
    $hiddenField = $('#selected_address_delivery_address')[0]
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

  $('div.delivery-address-option').click (event) ->
    onDeliveryAddressSelect(event)

  $('.add-delivery-address-link').click (event) ->
    $this = $('.add-new-delivery-address')

    $('#addNewAddress').css('top', $this.position().top)
    $('#addNewAddress').css('left', $this.position().left + 25)
    $('#addNewAddress').css('width', $this.width() + 40)
    $('#addNewAddress').fadeIn()

  $('div#addNewAddress .cancel').click ->
    $('#addNewAddress').fadeOut()

  $('#new_delivery_address').on("ajax:success", (e, data, status, xhr) ->
      $('#addNewAddress').fadeOut()

      $('.delivery-address-option').unbind 'click'
      $('.delivery-address-option').click (event) ->
        onDeliveryAddressSelect(event)

    ).on "ajax:error", (e, data, status, xhr) ->
      console.log(e)

  $('.edit-address').on 'ajax:success', (e, data, status, xhr) ->
    $addrBox = $(e.currentTarget.closest('.delivery-address-option'))
    $('#editDeliveryAddress').css('top', $addrBox.position().top)
    $('#editDeliveryAddress').css('left', $addrBox.position().left + 25)
    $('#editDeliveryAddress').css('width', $addrBox.width())
    $('#editDeliveryAddress').fadeIn();