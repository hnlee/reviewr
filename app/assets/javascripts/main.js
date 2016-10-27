$(document).ready(function () {
  console.log(window.location.pathname);

  $("#new-review-link").on("click", function(event) {
    event.preventDefault();

    var client = new Client();
    client.showNewReviewForm(getProjectIdFromURI(window.location.pathname));

  });

  getProjectIdFromURI = function(uri) {
    var pageURI = decodeURI(uri);
    var splitURI = pageURI.split("/");
    var projectId = splitURI[splitURI.length - 1];
    return parseInt(projectId);
  }


  $("#submit-review-button").on("click", function(event) {

    var client = new Client();
    client.submitReview(getProjectIdFromURI(window.location.pathname))

  });
});