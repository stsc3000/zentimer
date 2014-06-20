angular.module("analytics").
  service("Query", ($http, $q, TimerEntryList, AjaxAdapter, user) ->
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
            id: 'yesterday'
            name: 'YESTERDAY'
            date: moment().subtract('days', 1).startOf('day')
            headline: ->
              "#{@name}"
            subheadline: ->
              "#{@date.format("YYYY-MM-DD")}"
            toQuery: ->
              {
                from: moment(@date).startOf('day').toISOString()
                to: moment(@date).endOf('day').toISOString()
              }
          }
          {
            id: 'week'
            name: 'WEEK'
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
            name: 'MONTH'
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
            tertiary: true
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

        @entryList ||= new TimerEntryList([], adapter: AjaxAdapter, onSave: [_.bind(@onSave, @)])
        @entryList.setQueryData(data)

        @entryList.query().then (response) =>
          @paginatedEntries.clear()
          @pageIndex = 0
          @nextPage()
          @updateEntriesGroupedByProject()

      entriesGroupedByProject: []

      paginatedEntries: []
      pageIndex: 0
      perPage: 5

      csvUrl: ->
        @entryList.queryCsvUrl()

      updateEntriesGroupedByProject: ->
        grouped = _.groupBy(@entryList.entries, (entry) -> entry.project || "No Project")
        @entriesGroupedByProject = _.map grouped, (entries, project) ->
          sum = _.inject(entries, ((acc, entry) -> acc + entry.elapsed), 0)
          { key: project, value: sum }

      projectDomain: []

      fetchProjectDomain: ->
        $http.get("#{user.token}/projects").success (response) =>
          @projectDomain = response.projects

      tagDomain: []

      onSave: ->
        @updateEntriesGroupedByProject()

      fetchTagDomain: ->
        $http.get("#{user.token}/tags").success (response) =>
          @tagDomain = response.tags

      deleteEntry: (entry) ->
        @entryList.remove(entry)
        _.remove(@paginatedEntries, (searchEntry) -> searchEntry == entry)
        @updateEntriesGroupedByProject()
        @pageIndex = @pageIndex-1

      nextPage: ->
        _.each @entryList.entries.slice(@pageIndex, @perPage + @pageIndex), (entry) =>
          @paginatedEntries.push(entry)
        @pageIndex = @pageIndex + @perPage

    }

    Query.selectedDateFilter = Query.dateFilters[0]

    Query

  )
