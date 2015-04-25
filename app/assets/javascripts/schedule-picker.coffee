do ($ = jQuery) ->
  $.fn.schedulePicker = (options) ->
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
        defaults.serverDate = data.server_time.split("\s")[0]
        defaults.serverTime = data.server_time.split("\s")[1]
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
        return
      errror: ->
        console.log('error')



