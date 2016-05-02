class CentralAuthority.Views.StoreChainsStore extends Backbone.View

  template: JST['store_chains/store']

  tagName: 'tr'

  initialize: ->
    @model.on('change', @render, @)

  render: ->
    @$el.html(@template(store: @model))
    @
