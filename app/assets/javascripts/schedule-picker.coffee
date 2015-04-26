do ($ = jQuery) ->
  $.fn.schedulePicker = (options) ->

    # === Some constants ===
    # This is 9pm. Last delivery is between 9pm - 10pm
    LAST_DELIVERY_TIME = 21
    # Number of hours from now which you cannot select
    LEAD_TIME = 4
    # Number of days user can choose from
    DELIVERY_DATE_CHOICES = 9

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

    tableRowOperations =
      shouldBeAnEmptyCell: (rowIndex, cellIndex) ->
        rowIndex == 1 and cellIndex == 1
      isDateHeaderCell: (rowIndex, cellIndex) ->
        rowIndex == 1 and cellIndex > 1
      isTimeRangeCell: (rowIndex, cellIndex) ->
        cellIndex == 1 and rowIndex > 1
      createEmptyCell: (row) ->
        cell = $('<td>&nbsp;</td>')
        cell.css({'border-right' : '1px solid #fff'})
        row.append(cell)
      createDateHeaderCell: (row, label) ->
        cell = $("<td>#{label}</td>")
        cell.css({'text-align': 'center'})
        row.append(cell)
        row.css({'border-bottom' : '1px solid #fff'})
      createTimeRangeCell: (row, startTime) ->
        cell = $("<td>#{startTime}:00 - #{startTime + 2}:00</td>")
        cell.css({'border-right' : '1px solid #fff'})
        row.append(cell)
      createSelectableCell: (row, dateTimeAttribute) ->
        cell = $("<td class=\"selectable-cell\" date-time=\"#{dateTimeAttribute}\">&nbsp;</td>")
        row.append(cell)


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

        if daysToEndOfMonth < DELIVERY_DATE_CHOICES + 1
          row.append($("<td class=\"title\" colspan=\"#{daysToEndOfMonth}\">#{data.current_month_year}</td>"))
          row.append($("<td class=\"title\" colspan=\"#{DELIVERY_DATE_CHOICES - daysToEndOfMonth}\">#{data.next_month_year}</td>"))
        else
          row.append($("<td class=\"title\" colspan=\"#{DELIVERY_DATE_CHOICES}\">#{data.current_month_year}</td>"))

        table.append(row)
        table.css({'background-color': defaults.bgColor})

        # Time table
        for rowIndex in [1..8]
          row = $('<tr>')
          for cellIndex in [1..DELIVERY_DATE_CHOICES + 1]
            if tableRowOperations.shouldBeAnEmptyCell(rowIndex, cellIndex)
              tableRowOperations.createEmptyCell(row)
            else if tableRowOperations.isDateHeaderCell(rowIndex, cellIndex)
              cellText = data.choices[cellIndex - 2]['value']
              tableRowOperations.createDateHeaderCell(row, cellText)
            else if tableRowOperations.isTimeRangeCell(rowIndex, cellIndex)
              tableRowOperations.createTimeRangeCell(row, defaults.startTime)
              defaults.startTime += 2
            else
              dateValue = data.choices[cellIndex - 2]['key']
              tableRowOperations.createSelectableCell(row, dateValue)
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
          $(".schedule-table tr:nth-child(#{num}) td:nth-child(2)")
            .css({
              "background-color": "#dfdfdf",
              "border-bottom": "1px solid #fff"
            })
            .addClass("invalid-time")
            .removeClass("selectable-cell")

        return
      errror: ->
        # TODO - What to display on screen when we are not able to connect
        # TODO - to the database



