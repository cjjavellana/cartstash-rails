# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->

  formHelper =
    submitDelete: (anchorObject) ->
      authToken = $("input[name=\"authenticity_token\"]")

      form = $("<form/>", { action: anchorObject.attr("href"), method: 'post'})
      .append($("<input type=\"hidden\" name=\"_method\" value=\"delete\"/>"))
      .append(authToken)
      $("body").append(form)
      form.submit()

  $('.delete-payment-method').on 'click', ->
    anchor = $(this)

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
        formHelper.submitDelete(anchor)
    );

    false