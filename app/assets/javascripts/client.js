function Client() {
  this.response = '';
}

Client.prototype.showNewReviewForm = function(project_id) {
  $.ajax({
    url: "/reviews/new/" + project_id,
    type: "GET",
  })
  .done(function(response) {
    $("#new-review").html(response);
    $("#new-review-box").css("display", "none");
  });
};

Client.prototype.submitReview = function(project_id) {
  var form_data = $(this).serialize;
  $.ajax({
    type: "POST",
    data: form_data
  })
  .done(function(response) {
    $("#new-review").append(response);
  });
};

Client.prototype.showNewRatingForm = function(review_id) {
  $.ajax({
    url: "/ratings/new/" + review_id,
    type: "GET",
  })
  .done(function(response) {
    $("#new-rating").html(response);
    $("#new-rating-box").css("display", "none");
  });
};

Client.prototype.submitRating = function(review_id) {
  var form_data = $(this).serialize;
  $.ajax({
    type: "POST",
    url: "/ratings/new/" + review_id,
    data: form_data,
  })
  .done(function(response) {
    $("#new-rating").append(response);
  });
};
