class DratBrowser
  constructor: (options) ->
    @host = 'http://drat-demo.herokuapp.com'
    @url = "#{@host}/api/v1/resources.json?callback=?"

    @$list = $(options.list)

    @$filter_field = $('#list-filter')
    @$filter_field.bind 'keyup', (e) =>
      e.preventDefault()
      @start_filter()

    @get_resources_from_drat_api @display_resources

  start_filter: ->
    q = @search_value()
    if q is '' or q.length > 1
      @match_query(q)
    else
      @$list.children().show()

  search_value: -> return @$filter_field.val()

  match_query: (q) ->
    $items = @$list.children()

    for item in $items
      $item = $(item)
      $item.hide() if $item.data('name').search(new RegExp(q, 'i')) == -1

    return $items

  get_resources_from_drat_api: (callback) ->
    $.getJSON(@url).success(callback)

  display_resources: (resources) =>
    for resource in resources
      do (resource) =>
        cells = []
        cells.push(resource.name)

        resource_is_national = resource.national
        region = if resource_is_national then 'National' else "#{resource.state} #{resource.locale}"
        cells.push(region)

        categories = ''
        categories += "#{category}, " for category in resource.categories
        cells.push(categories)

        $available_to = $('<ul>')
        $available_to.append($('<li>').text(entity)) for entity in resource.available_to
        cells.push($available_to)

        $row = $('<tr>')
        $row.data('name', resource.name)
        $row.append($('<td>').html(cell)) for cell in cells

        @$list.append($row)

$ ->
  window.drat_browser = new DratBrowser list: $('#resource-list tbody')[0]

