(($, window) ->

  class CheckoutStageIndicator

    defaults:
      circleRadius: 50
      mainColor: '#EBEBEB'
      completedStageLineColor: '#4E4E4E'

    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)
      @$el = $(el)

    draw: () ->
      @$el.html('<div>Smile</div>')

      elWidth = @$el.width()
      stageInterval = elWidth / 4

      # define the origins of the 4 circles
      stageOrigins = []
      startOrigin = @options.circleRadius

      for x in [1 .. 4] by 1
        stageOrigins.push(startOrigin)
        startOrigin += stageOrigins


  $.fn.extend checkoutStageIndicator: (option, args) ->
    @each ->
      $this = $(this)
      data = $this.data('checkoutStageIndicator')

      if !data
        $this.data 'checkoutStageIndicator', (data = new CheckoutStageIndicator(this, option))

      if typeof option == 'string'
        data[option].apply(data, args)

) window.jQuery, window