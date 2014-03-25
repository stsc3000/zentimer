angular.module("analytics").
  service("Query", ($http, $q, Entry, user) ->
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

      tags: {
        include: []
        exclude: []
      }

      projects: []

      getDateFilter: ->
        _.find @dateFilters, (filter) => filter == @selectedDateFilter

      setDateFilter: (setFilter) ->
        @selectedDateFilter = setFilter
        @fetch()

      fetch: ->
        data = { token: user.token, query: {} }
        data.query.date_filter = @selectedDateFilter.toQuery()
        data.query.projects = @projects
        data.query.tags = @tags

        $http.post("/entries/filter", data).success (response) =>
          @entries = _.map response.entries, (entry) -> new Entry(entry)
          @paginatedEntries.clear()
          @pageIndex = 0
          @nextPage()
          @updateEntriesGroupedByProject()

      entries: []
      entriesGroupedByProject: []

      paginatedEntries: []
      pageIndex: 0
      perPage: 5

      total: ->
        _.reduce @entries, ((sum, entry) -> sum + entry.elapsed), 0

      updateEntriesGroupedByProject: ->
        grouped = _.groupBy(@entries, (entry) -> entry.project || "No Project")
        @entriesGroupedByProject = _.map grouped, (entries, project) ->
          sum = _.inject(entries, ((acc, entry) -> acc + entry.elapsed), 0)
          { key: project, value: sum }

      projectDomain: []

      fetchProjectDomain: ->
        $http.get("#{user.token}/projects").success (response) =>
          @projectDomain = response.projects

      tagDomain: []

      fetchTagDomain: ->
        $http.get("#{user.token}/tags").success (response) =>
          @tagDomain = response.tags

      deleteEntry: (entry) ->
        _.remove(@entries, (searchEntry) -> searchEntry == entry)
        @updateEntriesGroupedByProject()
        entry.delete()
        @pageIndex = @pageIndex-1

      nextPage: ->
        _.each @entries.slice(@pageIndex, @perPage + @pageIndex), (entry) =>
          @paginatedEntries.push(entry)
        console.log(@paginatedEntries.length)
        @pageIndex = @pageIndex + @perPage

    }

    Query.selectedDateFilter = Query.dateFilters[0]

    Query

  )
