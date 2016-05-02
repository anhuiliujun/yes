$(document).ready(function(){
  jQuery(function($){
    $(document).on("click","a.js-rest",function(){
      $("div#floatWindow").show();
      $("span#js-full_name").text($(this).data("name"));
      $("a.certain_btn.btn").attr("data-id", $(this).data('id'));
    });

    $(document).on("click", 'a.certain_btn.btn', function(){
      var password = $("input#password").val();
      var confirmation = $("input#confirmation").val();
      if(password.length < 6){
        alert("密码长度最少为6位！");
      }else if(password == confirmation){
        $.post("/mis/stores/"+ $(this).data("store") +"/store_staffs/"+$(this).data("id")+"",{_method: 'put', password: password, confirmation: confirmation},function(data){
        });
      }
      else{
        alert("请确认密码！");
      }
    });

    $("a.popups_cancel_btn.btn").on("click",function(){
      $("div#floatWindow").hide();
    });

    $("div.areaclose").on("click", function(){
      $("div#floatWindow").hide();
    });

  });

});
