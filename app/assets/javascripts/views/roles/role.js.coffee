class CentralAuthority.Views.Role extends Backbone.View

  template: JST['roles/role']

  tagName: 'tr'

  initialize: =>
    @model.on('change', @render, @)

  events:
    'click td.action a.del': 'destroy'

  render: ->
    @$el.html(@template(role: @model))
    @

  destroy: ->
    @model.off('sync')
    @model.destroy success: @redirectToIndex

  redirectToIndex: ->
    Backbone.history.navigate(Routes.roles_path(), {trigger: true })
