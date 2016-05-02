class CentralAuthority.Views.RolesIndex extends Backbone.View

  template: JST['roles/index']

  initialize: ->
    @collection.on('reset', @render, @)
    @collection.on('add', @appendRole, @)
    @collection.on('remove', @render, @)

  events:
    'submit': 'searchRoles'

  render: ->
    @$el.html(@template(roles: @collection))
    @collection.each(@appendRole)
    @

  searchRoles: ->
    event.preventDefault()
    params = $("form").toObject()
    query = { reset: true, data: params }
    @collection.fetch query

  appendRole: (role) =>
    view = new CentralAuthority.Views.Role(model: role)
    @$('#roles').append(view.render().el)
