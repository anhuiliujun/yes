class CentralAuthority.Views.StoreChainsNew extends Backbone.View

  template: JST['store_chains/new']

  initialize: ->
    @form = new CentralAuthority.Views.StoreChainForm(collection: @collection, model: new CentralAuthority.Models.StoreChain())

  render: ->
    @$el.html(@template(store: @model))
    @$el.append(@form.render().el)
    @
