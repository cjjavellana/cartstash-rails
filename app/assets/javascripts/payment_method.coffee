# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->
  $('.delete-payment-method').on 'click', ->
    swal({
      title: "Are you sure?",
      text: "You want to delete this payment method?"
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Yes, delete it!",
      cancelButtonText: "No, cancel!",
      closeOnConfirm: true,
      closeOnCancel: true
    }, (confirm) ->
      if confirm
        console.log('deleted')
      else
        console.log('deleted')
    );

    false