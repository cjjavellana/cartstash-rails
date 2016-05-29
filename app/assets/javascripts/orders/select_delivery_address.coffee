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