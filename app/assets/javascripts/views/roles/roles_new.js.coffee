class CentralAuthority.Views.RolesNew extends Backbone.View

  template: JST['roles/new']

  initialize: ->
    @form = new CentralAuthority.Views.RolesForm(model: new CentralAuthority.Models.Role(), collection: @collection)

  render: ->
    @$el.html(@template())
    @$el.append(@form.render().el)
    @
