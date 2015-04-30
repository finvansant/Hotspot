$(document).ready(function () {
  $.ajax({
    type:'get',
    data:{},
    url:'/map',
    dataType: 'html',
    success: function(result) {
      // replace page body
      $('body').html(result);
      // replace stylesheet
      $('link[href="css/load.css"').attr('href','css/map.css'); 
      initialize();
    }
  });
});