class CentralAuthority.Views.StoreChainForm extends Backbone.View

  template: JST['store_chains/form']

  initialize: ->
    Backbone.Validation.bind(@)
    @model.on('error', @handleError, @)
    @model.on('sync', @handleSuccess, @)
    @model.on('validated:invalid', @invalid, @)

  events:
    'submit': 'createOrUpdate'

  render: ->
    @$el.html(@template(store: @model))
    @

  invalid: (model, errors) ->
    @handleError(model, errors)

  createOrUpdate: ->
    event.preventDefault()
    @model.set $('form').toObject().store
    @model.save() if @model.isValid(true)

  handleSuccess: ->
    @collection.add @model
    Backbone.history.navigate(Routes.mis_store_chains_path(), {trigger: true })

  handleError: (model, responseOrErrors) ->
    if responseOrErrors && responseOrErrors.responseText
      new CentralAuthority.Views.ErrorView({el: @$("form"), attrsWithErrors: JSON.parse(responseOrErrors.responseText).errors}).render()
    else
      new CentralAuthority.Views.ErrorView({el: @$("form"), attrsWithErrors: responseOrErrors}).render()
