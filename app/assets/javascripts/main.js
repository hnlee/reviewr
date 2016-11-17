$(document).ready(function () {
  url = new Url();
  client = new Client();
  dom = new Dom();
  tab = new Tab();

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
    showRandomRatingForm(review_id, path_id, true);
  });

  $("#random-rating-down").on("click", function(event) {
    event.preventDefault();
    var review_id = $(this).parent().attr('data-id');
    showRandomRatingForm(review_id, path_id, false);
  });

  $("#new-rating-up").on("click", function(event) {
    event.preventDefault();
    showNewRatingForm(path_id, true);
  });

  $("#new-rating-down").on("click", function(event) {
    event.preventDefault();
    showNewRatingForm(path_id, false);
  });

   $("#submit-rating-button").on("click", function(event) {
     event.preventDefault();
     submitNewRatingForm(path_id);
  });

  $("#edit-review-link").on("click", function(event) {
    event.preventDefault();
    showEditReviewForm(path_id);
  });

  $("#edit-review-button").on("click", function(event) {
    event.preventDefault();
    submitEditReviewForm(path_id);
  });

  tab.showActiveTabContents(".tab-content", "#projects");

  $(".tab-container").on("click", "li", function(event) {
    event.preventDefault();
    var active_content_id = $("a", this).attr("href");

    tab.deactivateTab("li.active");
    tab.activateTab(this);

    tab.showActiveTabContents(".tab-content",
                              active_content_id);
  });

  assignIds("#invites .form-input", "input_");

  $("#add-invite-link").on("click", function(event) {
    addField("#invites", "#new-invite-field");
    assignIds(".remove-invite-link", "remove_invite_");
    assignIds("#invites .form-input", "input_");

    $(".remove-invite-link").on("click", function(event) {
      var index = getIdIndex(this, "remove_invite_");
      removeElement("#input_", index);
      removeElement("#remove_invite_", index);
    });
  });
});
