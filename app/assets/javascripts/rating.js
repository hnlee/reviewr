var client = new Client();
var dom = new Dom();

showNewRatingForm = function(review_id, thumb) {
  var param = addThumbParam(thumb);
  showRatingForm(review_id, param);
};

submitNewRatingForm = function(review_id, callback) {
  client.ajaxPost("/ratings/new/" + review_id,
                  callback);
};

showRandomRatingForm = function(review_id, user_id, thumb) {
  var param = addThumbParam(thumb);
  if (param == "") {
    param = "?random=true&user=" + user_id;
  } else {
    param = param + "&random=true&user=" + user_id;
  }
  showRatingForm(review_id, param)
};

addThumbParam = function(thumb) {
  if (thumb == true) {
    param = "?thumb=up";
  } else if (thumb == false) {
    param = "?thumb=down";
  } else {
    param = "";
  }
  return param;
};

showRatingForm = function(review_id, param) {
  var callback = function(response) {
    dom.displayPartial("#new-rating", response);
    dom.hideElement("#new-rating-box");
    dom.hideElement("#rating-criteria");
  };
  client.ajaxGet("/ratings/new/" + review_id + param,
                 callback);
}