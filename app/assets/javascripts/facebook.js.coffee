$(document).on 'page:change', ->

  if $('#facebook-jssdk')
    return

  script = $('<script id=\'facebook-jssdk\'></script>')
  script.attr('src', '//connect.facebook.net/en_US/sdk.js')

  window.fbAsyncInit = ->
    FB.init({
      appId      : '619483178191291',
      xfbml      : true,
      version    : 'v2.3'
    });


