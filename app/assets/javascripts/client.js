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
    $("#new-review-link").css("display", "none");
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
