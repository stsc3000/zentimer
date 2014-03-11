angular.module("analytics").
  service("Query", ($http, $q, user) ->
    Query = {
      dateFilters: 
        [
          {
            id: 'today'
            name: 'TODAY'
            date: moment().startOf('day')
            headline: ->
              "#{@name}"
            subheadline: ->
              "#{@date.format("YYYY-MM-DD")}"
            toQuery: ->
              { 
                from: moment(@date).startOf('day').toISOString()
                to: moment(@date).endOf('day').toISOString()
              }
          },
          {
            id: 'week'
            name: 'THIS WEEK'
            from: moment().startOf('week')
            to: moment().endOf('week')
            headline: ->
              "#{@name}"
            subheadline: ->
              "#{@from.format('YYYY-MM-DD')} - #{@to.format('YYYY-MM-DD')}"
            toQuery: ->
              { 
                from: moment(@from).startOf('day').toISOString()
                to: moment(@to).endOf('day').toISOString()
              }

          },
          {
            id: 'month'
            name: 'THIS MONTH'
            from: moment().startOf('month')
            to: moment().endOf('month')
            headline: ->
              "#{@name}"
            subheadline: ->
              "#{@from.format('YYYY-MM-DD')} - #{@to.format('YYYY-MM-DD')}"
            toQuery: ->
              { 
                from: moment(@from).startOf('day').toISOString()
                to: moment(@to).endOf('day').toISOString()
              }

          },
          {
            id: 'fromTo'
            name: 'FROM - TO'
            from: (new Date)
            to: (new Date)
            headline: ->
              "#{@name}"
            subheadline: ->
              "#{moment(@from).format('YYYY-MM-DD')} - #{moment(@to).format('YYYY-MM-DD')}"
            toQuery: ->
              { 
                from: moment(@from).startOf('day').toISOString()
                to: moment(@to).endOf('day').toISOString()
              }

          }
        ]

      getDateFilter: ->
        _.find @dateFilters, (filter) => filter == @selectedDateFilter

      setDateFilter: (setFilter) ->
        @selectedDateFilter = setFilter
        @fetch()

      fetch: ->
        data = { token: user.token, query: {} }
        data.query.date_filter = @selectedDateFilter.toQuery()

        $http.post("/entries/filter", data).success (response) =>
          @entries = response.entries

      entries: []

      total: ->
        _.reduce @entries, ((sum, entry) -> sum + entry.elapsed), 0
    }

    Query.selectedDateFilter = Query.dateFilters[0]

    Query

  )
