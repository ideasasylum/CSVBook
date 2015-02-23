
jQuery ->

  $('#csvfile').on 'change', () ->
    console.log 'csv file changed'
    $('#csvfile').parse {
      config: {
        header: true
        skipEmptyLines: true
        complete: (results) ->
          console.log results
          setup results
      }
    }

  $('#previous').on 'click', () ->
    previous()

  $('#next').on 'click', () ->
    next()

  $(document).on 'keydown', (event) ->
    if event.keyCode == 37
      previous()
    else if event.keyCode == 39
      next()


  setup = (results) ->
    window.csvbook.results = results
    window.csvbook.current_page = 0
    render_page()

  render_page = () ->
    data = get_row current_page()
    fields = _.map data, (value, key) ->
      {key: key, value: value}
    page = window.csvbook.page_template(data)
    $('#csvbook').html page

  previous = () ->
    if page_exists previous_page()
      window.csvbook.current_page = previous_page()
      render_page()

  next = () ->
    if page_exists next_page()
      window.csvbook.current_page = next_page()
      render_page()

  get_row = (row) ->
    window.csvbook.results.data[row]

  current_page = () ->
    window.csvbook.current_page

  next_page = () ->
    current_page() + 1

  previous_page = () ->
    current_page() - 1

  page_exists = (page) ->
    page >= 0 && page < window.csvbook.results.data.length

  Handlebars.registerHelper 'simple_format', (text, options) ->
    text = text.replace(/\r\n?/, "\n")
    text = $.trim(text)
    if (text.length > 0)
      text = text.replace(/\n\n+/g, '</p><p>')
      text = text.replace(/\n/g, '<br />')
      text = '<p>' + text + '</p>'

    return new Handlebars.SafeString(text)


  window.csvbook = {}
  window.csvbook.render_page = render_page
  window.csvbook.template_source = $("#page-template").html()
  window.csvbook.page_template = Handlebars.compile window.csvbook.template_source
