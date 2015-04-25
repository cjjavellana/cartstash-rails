do ($ = jQuery) ->
  $.fn.schedulePicker = (options) ->

    # Some constants
    LAST_DELIVERY_TIME = 21 # 9pm
    LEAD_TIME = 4 # In hours

    defaults =
      startTime: 8
      endTime: 22
      numberOfDays: 7
      timeInterval: 2
      serverDate: ""
      serverTime: ""
      tableTitle: ""
      fontColor: '#fff'
      bgColor: 'rgba(255,255,255,0.3)'

    options = $.extend(defaults, options)

    divContainer = $(this)

    $.ajax
      url: '/server-date'
      type: 'get'
      success: (data, status, response) ->
        # Read response from server
        defaults.serverDate = data.server_time.split(" ")[0]
        defaults.serverTime = data.server_time.split(" ")[1]
        daysToEndOfMonth = parseInt(data.till_end_of_month) + 1

        # Create the table
        table = $('<table class="table schedule-table">')
        row = $('<tr>')
        row.append($('<td>'))

        if daysToEndOfMonth < 10
          row.append($("<td class=\"title\" colspan=\"#{daysToEndOfMonth}\">#{data.current_month_year}</td>"))
          row.append($("<td class=\"title\" colspan=\"#{9 - daysToEndOfMonth}\">#{data.next_month_year}</td>"))
        else
          row.append($("<td class=\"title\" colspan=\"9\">#{data.current_month_year}</td>"))

        table.append(row)
        table.css({'background-color': defaults.bgColor})

        # Time table
        for rowNum in [1..8]
          row = $('<tr>')
          for cellNum in [1..10]
            if rowNum == 1 and cellNum == 1
              # Empty cell
              cell = $('<td>&nbsp;</td>')
              cell.css({'border-right' : '1px solid #fff'})
              row.append(cell)
            else if rowNum == 1 and cellNum > 1
              # The date choices
              cellText = data.choices[cellNum - 2]
              cell = $("<td>#{cellText}</td>")
              cell.css({'text-align': 'center'})
              row.append(cell)
              row.css({'border-bottom' : '1px solid #fff'})
            else if cellNum == 1 and rowNum > 1
              # The time choices
              cell = $("<td>#{defaults.startTime}:00 - #{defaults.startTime + 2}:00</td>")
              cell.css({'border-right' : '1px solid #fff'})
              row.append(cell)
              defaults.startTime += 2
            else
              cell = $('<td class="selectable-cell">&nbsp;</td>')
              row.append(cell)

          table.append(row)

        divContainer.append(table)

        # Prepare the lookup table
        # Row 3: 8-10
        # Row 4: 10-12
        # Row 5: 12-2
        # Row 6: 2-4
        # Row 7: 4-6
        # Row 8: 6-8
        # Row 9: 8-10
        rowIndex = 3
        timeLookupTable = {}
        for time in [8..20] by 2
          timeLookupTable[time] = timeLookupTable[time + 1] = rowIndex
          rowIndex++

        # Mark out the cells which the user cannot select
        # 4 being the lead time from now
        currentHour = parseInt(defaults.serverTime.split(":")) + LEAD_TIME
        currentHour = LAST_DELIVERY_TIME if currentHour > LAST_DELIVERY_TIME

        for num in [timeLookupTable[currentHour]..3]
          $(".schedule-table tr:nth-child(#{num}) td:nth-child(2)").css({
            "background-color": "#dfdfdf",
            "border-bottom": "1px solid #fff"
          }).addClass("invalid-time").removeClass("selectable-cell")

        return
      errror: ->
        # TODO - What to display on screen when we are not able to connect
        # TODO - to the database



