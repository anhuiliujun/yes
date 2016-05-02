class CentralAuthority.Models.Role extends Backbone.Model

  urlRoot: '/api/roles'

  validation: {
    name: { 
      required: true,
      msg: '名称不能为空'
    },
    abbrev: { 
      required: true,
      msg: '代码不能为空'
    }
  }
