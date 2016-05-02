class CentralAuthority.Views.RolesShow extends Backbone.View

  template: JST['roles/show']

  initialize: ->
    @model.on('sync', @render, @)
    @model.on('change', @render, @)

  render: ->
    @$el.html(@template(role: @model))
    @
