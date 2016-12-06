function Review() {
  var client = new Client();
  var dom = new Dom(); 
}

Review.prototype.showNewReviewForm = function(project_id) {
  var callback = function(response) {
    dom.displayPartial("#new-review",
                       response);
    dom.hideElement("#new-review-link");
  };
  client.ajaxGet("/reviews/new/" + project_id,
                 callback); 
};

Review.prototype.submitNewReviewForm = function(project_id, callback) {
  client.ajaxPost("/reviews/new/" + project_id,
                  callback);
};

Review.prototype.showEditReviewForm = function(review_id) {
  var callback = function(response) {
    dom.displayPartial("#edit-review", response);
    dom.hideElement("#edit-review-link");
    dom.hideElement("#review-content");
    dom.replaceContent("#page-title", "Update review");
  };
  client.ajaxGet("/reviews/" + review_id + "/edit",
                 callback);
};

Review.prototype.submitEditReviewForm = function(review_id, callback) {
  client.ajaxPost("/reviews/" + review_id + "/edit",
                  callback);
};
