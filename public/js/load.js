$(document).ready(function () {
  $.ajax({
    type:'get',
    data:{},
    url:'/map',
    dataType: 'html',
    success: function(result) {
      $('body').html(result);
      $('link[href="css/load.css"').attr('href','css/map.css');
      initialize();
    }
  });
});