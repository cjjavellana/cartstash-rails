$(document).on 'page:change', ->
  markers = []

  # Manage delivery address specific javascripts
  if $('.add-delivery-address-header, .edit-delivery-address-header').length > 0
    CartStashGmapHelper =
      clearMapMarkers: (markers) ->
        for marker in markers
          marker.setMap(null)
        markers = []

    handler = Gmaps.build('Google')
    handler.buildMap({provider: {zoom: 17}, internal: {id: 'geolocation'}}, ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition((position)->
          handler.map.centerOn({lat: position.coords.latitude, lng: position.coords.longitude});
        );

      # event handlers
      google.maps.event.addListener(handler.getMap(), 'click',(e) ->
          CartStashGmapHelper.clearMapMarkers(markers)

          marker = new google.maps.Marker({
            position: e.latLng,
            map: handler.getMap()
          })

          markers.push(marker)

          $('#delivery_address_location_coords').val("#{e.latLng.lat()}, #{e.latLng.lng()}")
          return
      )
    )

    # set marker (if any)
    coords = $('#delivery_address_location_coords').val()
    if coords.match(/^[-]?\d*\.\d*,\s[-]?\d*\.\d*$/)
      console.log('Setting marker at: ' + coords)
      lat = coords.split(',')[0]
      lng = coords.split(',')[1]
      latlng = new google.maps.LatLng(lat, lng)
      marker = new google.maps.Marker({
        position: latlng,
        map: handler.getMap()
      })
      markers.push(marker)

  if $('.add-delivery-address-header').length > 0
    $('#same_recipient').on 'click', ->
      if $(this).is(':checked')
        $('#delivery_address_recipient_name').val($('#user').val())
        $('#delivery_address_recipient_name').attr('readonly', true)
      else
        $('#delivery_address_recipient_name').val('')
        $('#delivery_address_recipient_name').attr('readonly', false)


  if $('.edit-delivery-address-header').length > 0
    $('#same_recipient').on 'click', ->
      if $(this).is(':checked')
        $('#delivery_address_recipient_name').val($('#current_user_name').val())
        $('#delivery_address_recipient_name').attr('readonly', true)
      else
        $('#delivery_address_recipient_name').attr('readonly', false)