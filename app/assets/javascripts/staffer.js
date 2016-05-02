$(document).ready(function(){
  // staffer with agent -- index
  $(document).on('click','td.toggle a',function(){
    $(this).parent().parent().addClass("current").siblings().removeClass("current");
    var title = "您确定" + $(this).text() + "管理员" + "<span>" + $("tr.current").data("fullname") + "</span>?"
    $("#toggle_dialog .title").html(title);
    $("#toggle_dialog").show();
  })

  $("a.certain_btn.btn").click(function(){
    $.post("/mis/staffers/"+ $("tr.current").data("id") +"/toggle",function(data){
    })
  })

  $("a.popups_cancel_btn.btn").click(function(){
    $("#toggle_dialog").hide();
  })


  // Agent -- edit
  $("i.fa.fa-plus.plus").click(function(){
    $("div#add").show();
  })

  $("a.save_btn.btn").click(function(){
    var amount = $("input#money").val();
    var quantity = $("input#quantity").val();
    $("div#confirm_dialog").show();
    var title = "您确定续费" + amount + "元，" + "<span>" + "添加"+ quantity + "个门店吗" + "</span>?"
    $("div#confirm_dialog .title").html(title)
  })

  $("a#congirm_to_payment").click(function(){
    var stafferId = $(this).data("id")
    var staffer = $(this).data("creator")
    var amount = $("input#money").val();
    var price = $("input#price").val();
    var quantity = $("input#quantity").val();
    $.post("/mis/staffers/"+ stafferId +"/agent_payments",{amount: amount, price: price, quantity: quantity, creator_id: staffer }, function(data){
      $("div#confirm_dialog").hide();
      $("div#add").hide();
    })
  })

  $("a.popups_cancel_btn.btn").click(function(){
    $("div#confirm_dialog").hide();
  })

  $("input#price").keyup(function(){
    var amount = $("input#money").val();
    var price = $(this).val();
    $("input#quantity").val(amount/price);
  });

  $("a.cancel_btn.btn").click(function(){
    $("div#add").hide();
  })


});
