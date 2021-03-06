// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// callbacks executed when purchase order is updated from
// the popover order summary
var updatePurchaseOrderCallbacks = $.Callbacks('unique');

$(document).ready(function(){
    $('.welcome').bind('mouseover', function(){
        $('.profile-context-menu').width($('.user-info').width());
        $('.profile-context-menu').show();
    });

    $('.profile-context-menu').bind('mouseleave', function(){
        $('.profile-context-menu').hide();
    });
});