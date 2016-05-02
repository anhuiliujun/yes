$(function(){
  var date = new Date();
  var maxDate = date.getFullYear() + '/' + (date.getMonth()+1) + '/' + date.getDate();
  var maxTime = date.getHours() + ':' + date.getMinutes();
  $('#datetimepicker').datetimepicker({
    lang: 'ch',
    minDate: '2012/01/01',
    maxDate: maxDate,
    maxTime: maxTime,
    onSelectTime: function(){
      var flag = 0;
      var selectDate = $('#datetimepicker').val().split(' ')[0];
      var selectYear = selectDate.split('/')[0];
      var selectMonth = selectDate.split('/')[1];
      var selectDay = selectDate.split('/')[2];
      flag = selectYear <= date.getFullYear() ? 1 : 0;
      if(flag){
        flag = selectMonth <= (date.getMonth() + 1) ? 1 : 0;
        if(flag){
          flag = selectDay <= date.getDate() ? 1 : 0;
        }
      }
      if(!flag){
        $('#datetimepicker').val(maxDate + ' ' + maxTime);
      }
    }
  });
});
