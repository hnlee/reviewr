var client = new Client();
var dom = new Dom(); 

showNewReviewForm = function(project_id) {
  var callback = function(response) {
    dom.displayPartial("#new-review",
                       response);
    dom.hideElement("#new-review-box");
  };
  client.ajaxGet("/reviews/new/" + project_id,
                 callback); 
};

submitNewReviewForm = function(project_id, callback) {
  //var callback = function(response) {
  //};
  client.ajaxPost("/reviews/new/" + project_id,
                  callback);
};

showEditReviewForm = function(review_id) {
  var callback = function(response) {
    dom.displayPartial("#edit-review", response);
    dom.hideElement("#edit-review-link");
    dom.hideElement("#review-content");
    dom.replaceContent("#page-title", "Update review");
  };
  client.ajaxGet("/reviews/" + review_id + "/edit",
                 callback);
};

submitEditReviewForm = function(review_id, callback) {
  //var callback = function(response) {
  //};
  client.ajaxPost("/reviews/" + review_id + "/edit",
                  callback);
};
