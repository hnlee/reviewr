function Client() {
}

Client.prototype.ajaxGet = function(url, callback) {
  $.ajax({
    url: url,
    type: "GET",
  })
  .done(callback);
};

Client.prototype.ajaxPost = function(url, callback) {
  var form_data = $(this).serialize;
  $.ajax({
    url: url,
    type: "POST",
    data: form_data,  
  })
  .done(callback);
};

