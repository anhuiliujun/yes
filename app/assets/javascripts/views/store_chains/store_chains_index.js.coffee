class CentralAuthority.Views.StoreChainsIndex extends Backbone.View

  template: JST['store_chains/index']

  initialize: ->
    @collection.on('reset', @render, @)
    @collection.on('add', @appendStore, @)
    @collection.on('remove', @render, @)

  events:
    'submit': 'searchStoreChain'

  render: ->
    @$el.html(@template(stores: @collection))
    @collection.each(@appendStore)
    @

  appendStore: (store) =>
    view = new CentralAuthority.Views.StoreChainsStore(model: store)
    @$('#stores').append(view.render().el)

  searchStoreChain: ->
    event.preventDefault()
    params = $('form').toObject()
    query = { reset: true, data: params }
    @collection.fetch query
