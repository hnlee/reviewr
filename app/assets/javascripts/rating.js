var client = new Client();
var dom = new Dom();

showNewRatingForm = function(review_id, thumb) {
  if (thumb == true) {
    param = "?thumb=up"
  } else if (thumb == false) {
    param = "?thumb=down"
  } else {
    param = ""
  }
  var callback = function(response) {
    dom.displayPartial("#new-rating", response);
    dom.hideElement("#new-rating-box");
    dom.hideElement("#rating-criteria");
  };
  client.ajaxGet("/ratings/new/" + review_id + param,
                 callback);
};

submitNewRatingForm = function(review_id, callback) {
  //var callback = function(response) {
  //};
  client.ajaxPost("/ratings/new/" + review_id,
                  callback);
};
