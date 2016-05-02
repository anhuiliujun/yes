class CentralAuthority.Views.RolesEdit extends Backbone.View

  template: JST['roles/edit']

  initialize: ->
    @form = new CentralAuthority.Views.RolesForm(model: @model, collection: @collection)

  render: ->
    @$el.html(@template(role: @model))
    @$el.append(@form.render().el)
    @
