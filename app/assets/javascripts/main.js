$(document).ready(function () {
  url = new Url();
  client = new Client();
  dom = new Dom();

  var path_id = url.getIdFromURI(window.location.pathname);
  
  $("#new-review-link").on("click", function(event) {
    event.preventDefault();
    showNewReviewForm(path_id);
  });

  $("#submit-review-button").on("click", function(event) {
    event.preventDefault();
    submitNewReviewForm(path_id);
  });

  $("#random-rating-up").on("click", function(event) {
    event.preventDefault();
    var review_id = $(this).parent().attr('data-id');
    var user_id = path_id
    showRandomRatingForm(review_id, user_id, true);
  });

  $("#random-rating-down").on("click", function(event) {
    event.preventDefault();
    var review_id = $(this).parent().attr('data-id');
    var user_id = path_id
    showRandomRatingForm(review_id, user_id, false);
  });

  $("#new-rating-up").on("click", function(event) {
    event.preventDefault();
    showNewRatingForm(path_id, true);
  });
 
  $("#new-rating-down").on("click", function(event) {
    event.preventDefault();
    showNewRatingForm(path_id, false);
  });

   $('#submit-rating-button').on("click", function(event) {
     event.preventDefault();
     submitNewRatingForm(path_id);
  });

  $('#edit-review-link').on("click", function(event) {
    event.preventDefault();
    showEditReviewForm(path_id);
  });

  $('#edit-review-button').on("click", function(event) {
    event.preventDefault();
    submitEditReviewForm(path_id);
  });

});
