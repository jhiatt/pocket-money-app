/* global Vue */
/* global $ */

document.addEventListener("DOMContentLoaded", function(event) { 
  var app = new Vue({
    el: '#app-events',
    data: {
      message: 'Hello Vue!'
    }
  });
});

$(function() {
  $(".description").each(function(i) {
    var len = $(this).text().length;
    if (len > 20) {
      $(this).text($(this).text().substr(0,20) + '...');
    }
  });
});