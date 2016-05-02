class CentralAuthority.Views.RolesForm extends Backbone.View

  template: JST['roles/form']

  initialize: ->
    Backbone.Validation.bind(@)
    @model.on('error', @handleError, @)
    @model.on('sync', @handleSuccess, @)
    @model.on('validated:invalid', @invalid, @)

  events:
    'submit': 'createOrUpdate'

  render: ->
    @$el.html(@template(role: @model))
    @

  invalid: (model, errors) ->
    @handleError(model, errors)

  createOrUpdate: ->
    event.preventDefault()
    @model.set $('form').toObject().role
    @model.save() if @model.isValid(true)

  handleSuccess: ->
    @collection.add @model
    Backbone.history.navigate(Routes.role_path(@model), {trigger: true })

  handleError: (model, responseOrErrors) ->
    if responseOrErrors && responseOrErrors.responseText
      new CentralAuthority.Views.ErrorView({el: @$("form"), attrsWithErrors: JSON.parse(responseOrErrors.responseText).errors}).render()
    else
      new CentralAuthority.Views.ErrorView({el: @$("form"), attrsWithErrors: responseOrErrors}).render()
