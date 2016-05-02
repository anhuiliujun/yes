function show_dialog(){
  var store_name = $(this).parent().parent().children('td:eq(3)').html();
  var operation = $(this).html();
  $('.disable_store_wrap .title span').html('您确定' + operation + '门店"' + store_name + '"?');
  $('.disable_store_wrap').attr('data-id', $(this).attr('data-id'));
  $('.disable_store_wrap').show();
}

function hide_dialog(){
  $('.disable_store_wrap .reason').val('');
  $('.disable_store_wrap').hide();
}

function toggle_available(){
  var reason = $('.disable_store_wrap .reason').val().trim();
  if(reason == null || reason == ''){
    alert('理由不能为空!');
  }
  else{
    $.ajax({
      url: '/mis/stores/'+ $('.disable_store_wrap').attr("data-id"),
      type: 'put',
      data: {reason: reason},
      success: function(){
        hide_dialog();
        location.reload();
      }
    });
  }
}
$(function(){
  $(document).on('click', '.stop', show_dialog);
  $(document).on('click', '.recover', show_dialog);
  $(document).on('click', '.disable_store_wrap .popups_cancel_btn', hide_dialog);
  $(document).on('click', '.disable_store_wrap .certain_btn', toggle_available);
});
