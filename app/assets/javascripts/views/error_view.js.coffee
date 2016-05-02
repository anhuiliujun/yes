class CentralAuthority.Views.ErrorView extends Backbone.View
  initialize: (options) ->
    @attrsWithErrors = options.attrsWithErrors

  render: ->
    @clearOldErrors()
    @renderErrors()

  clearOldErrors: =>
    @$("span.message").remove()
    @$(".field_with_errors input").unwrap()

  renderErrors: =>
    _.each(@attrsWithErrors, @renderError)

  renderError: (errors, attr) =>
    errorString = if typeof errors == 'string' then errors else errors.join(", ")
    field = @fieldFor(attr)
    errorTag = $('<span>').addClass('message').text(errorString)
    field.wrap("<div>")
    field.parent().append(errorTag)
    field.parent().addClass('field_with_errors')

  fieldFor: (attr) =>
    @$("input[id*='_#{attr}']")
