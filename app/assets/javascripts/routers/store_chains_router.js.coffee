class CentralAuthority.Routers.StoreChains extends Backbone.Router
  routes:
    'mis/store_chains': 'index'
    'mis/store_chains/:id/edit': 'edit'
    'mis/store_chains/new': 'new'

  initialize: ->
    @collection = new CentralAuthority.Collections.StoreChains()
    @collection.reset($('#container').data()['storeChains'])

  index: ->
    view = new CentralAuthority.Views.StoreChainsIndex(collection: @collection)
    $('#container').html(view.render().el)

  edit: (id) ->
    model = @collection.get(id)
    view = new CentralAuthority.Views.StoreChainsEdit(model: model, collection: @collection)
    $('#container').html(view.render().el)

  new: ->
    view = new CentralAuthority.Views.StoreChainsNew(collection: @collection)
    $('#container').html(view.render().el)
