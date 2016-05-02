window.CentralAuthority =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: -> 
    new CentralAuthority.Routers.StoreChains
    new CentralAuthority.Routers.Roles
    Backbone.history.start()

$(document).ready ->
  CentralAuthority.initialize()
