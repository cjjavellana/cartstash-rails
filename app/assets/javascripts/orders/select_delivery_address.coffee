$(document).on 'page:change', ->
  $('.delivery-address-option').click (event) ->
    $hiddenField = $('#checkout_selected_address')[0]
    currentValue = $hiddenField.value
    selectedValue = $(event.target).attr('data')

    # If toggling out
    if currentValue == selectedValue
      $hiddenField.value = ''
      $("[data='" + selectedValue + "']").css('border', '1px solid #EBEBEB')
    else
      $hiddenField.value = selectedValue
      $("[data='" + selectedValue + "']").css('border', '3px solid #EF912D')
      if currentValue != ''
        $("[data='" + currentValue + "']").css('border', '1px solid #EBEBEB')