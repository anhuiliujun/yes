class CentralAuthority.Views.StoreChainsEdit extends Backbone.View

  template: JST['store_chains/edit']

  initialize: ->
    @form = new CentralAuthority.Views.StoreChainForm(model: @model, collection: @collection)

  render: ->
    @$el.html(@template(store: @model))
    @$el.append(@form.render().el)
    @

