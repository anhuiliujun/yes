class CentralAuthority.Models.StoreChain extends Backbone.Model

  urlRoot: '/api/store_chains'

  validation: {
    name: { 
      required: true,
      msg: '名称不能为空'
    }
  }
