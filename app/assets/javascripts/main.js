$(document).ready(function () {
  console.log(window.location.pathname);

  $("#new-review-link").on("click", function(event) {
    event.preventDefault();
    var client = new Client();
    client.showNewReviewForm(getIdFromURI(window.location.pathname));
  });

  $("#submit-review-button").on("click", function(event) {
    var client = new Client();
    client.submitReview(getIdFromURI(window.location.pathname));
  });

  $("#new-rating-link").on("click", function(event) {
    event.preventDefault();
    var client = new Client();
    client.showNewRatingForm(getIdFromURI(window.location.pathname));
  });

  $('#submit-rating-button').on("click", function(event) {
    var client = new Client();
    client.submitRating(getIdFromURI(window.location.pathname));
  });

  $('#edit-review-link').on("click", function(event) {
    event.preventDefault();
    var client = new Client();
    client.showEditReviewForm(getIdFromURI(window.location.pathname));
  });

  $('#edit-review-button').on("click", function(event) {
    var client = new Client();
    client.updateReview(getIdFromURI(window.location.pathname));
  });

  getIdFromURI = function(uri) {
    var pageURI = decodeURI(uri);
    var splitURI = pageURI.split("/");
    var id = splitURI[splitURI.length - 1];
    return parseInt(id);
  };
});
