class CentralAuthority.Routers.Roles extends Backbone.Router
  routes:
    'roles': 'index'
    'roles/new': 'new'
    'roles/:id': 'show'
    'roles/:id/edit': 'edit'

  initialize: ->
    @collection = new CentralAuthority.Collections.Roles()
    @collection.reset($('#container').data()['roles'])
    #setInterval @request, 5000

  index: ->
    view = new CentralAuthority.Views.RolesIndex(collection: @collection)
    $('#container').html(view.render().el)

  show: (id) ->
    view = new CentralAuthority.Views.RolesShow(model: @collection.get(id))
    $('#container').html(view.render().el)

  new: ->
    view = new CentralAuthority.Views.RolesNew(collection: @collection)
    $('#container').html(view.render().el)

  edit: (id) ->
    view = new CentralAuthority.Views.RolesEdit(model: @collection.get(id), collection: @collection)
    $('#container').html(view.render().el)

  request: =>
    @collection.fetch()
