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

Client.prototype.showNewRatingForm = function(review_id, thumb) {
  if (thumb == true) {
    thumb_param = "?thumb=up"
  } else if (thumb == false) {
    thumb_param = "?thumb=down"
  } else {
    thumb_param = "" 
  }
  $.ajax({
    url: "/ratings/new/" + review_id + thumb_param,
    type: "GET",
  })
  .done(function(response) {
    $("#new-rating").html(response);
    $("#new-rating-box").css("display", "none");
    $("#rating-criteria").css("display", "none");
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

Client.prototype.showEditReviewForm = function(review_id) {
  $.ajax({
    url: "/reviews/" + review_id + "/edit",
    type: "GET",
  })
  .done(function(response) {
    $("#edit-review").html(response);
    $("#edit-review-link").css("display", "none");
    $("#review-content").css("display", "none");
  });
};

Client.prototype.updateReview = function(review_id) {
  var form_data = $(this).serialize;
  $.ajax({
    type: "POST",
    data: form_data,
  })
  .done(function(response) {
    $("#edit-review").append(response);
  });
};
