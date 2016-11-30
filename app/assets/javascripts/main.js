$(document).ready(function () {
  url = new Url();
  client = new Client();
  dom = new Dom();
  tab = new Tab();

  var path_id = url.getIdFromURI(window.location.pathname);
  var unsavedForm;

  $("#new-review-link").on("click", function(event) {
    event.preventDefault();
    showNewReviewForm(path_id);
  });

  $("#submit-review-button").on("click", function(event) {
    event.preventDefault();
    submitNewReviewForm(path_id);
    unsavedForm = false;
  });

  $("#random-rating-up").on("click", function(event) {
    event.preventDefault();
    var review_id = $(this).parent().attr('data-id');
    showRandomRatingForm(review_id, path_id, true);
    unsavedForm = true;
  });

  $("#random-rating-down").on("click", function(event) {
    event.preventDefault();
    var review_id = $(this).parent().attr('data-id');
    showRandomRatingForm(review_id, path_id, false);
    unsavedForm = true;
  });

  $("#new-rating-up").on("click", function(event) {
    event.preventDefault();
    showNewRatingForm(path_id, true);
    unsavedForm = true;
  });

  $("#new-rating-down").on("click", function(event) {
    event.preventDefault();
    showNewRatingForm(path_id, false);
    unsavedForm = true;
  });

  $("#submit-rating-button").on("click", function(event) {
     event.preventDefault();
     submitNewRatingForm(path_id);
     unsavedForm = false;
  });

  $("#edit-review-link").on("click", function(event) {
    event.preventDefault();
    showEditReviewForm(path_id);
    unsavedForm = true;
  });

  $("#edit-review-button").on("click", function(event) {
    event.preventDefault();
    submitEditReviewForm(path_id);
    unsavedForm = false;
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
  assignIds(".remove-invite-link", "remove_invite_");

  $("#add-invite-link").on("click", function(event) {
    event.preventDefault();
    dom.unhideElement(".remove-invite-link");
    addField("#invites", "#new-invite-field");
    assignIds(".remove-invite-link", "remove_invite_");
    assignIds("#invites .form-input", "input_");
    
    $(".remove-invite-link").on("click", function(event) {
      var index = getIdIndex(this, "remove_invite_");
      removeElement("#input_", index);
      removeElement("#remove_invite_", index);
    });
  });

  $(".remove-invite-link").on("click", function(event) {
    var index = getIdIndex(this, "remove_invite_");
    removeElement("#input_", index);
    removeElement("#remove_invite_", index);
  });

  $("#submit-project-button").on("click", function(event) {
    if(isFieldBlank("#invites .form-input")) {
      event.preventDefault();
      dom.replaceContent(".alert-error", "<p>Please input an email address</p><br />");
    }
    unsavedForm = false;
  });

  $("#edit-project-button").on("click", function(event) {
    if(isFieldBlank("#invites .form-input")) {
      event.preventDefault();
      dom.replaceContent(".alert-error", "<p>Please input an email address</p><br />");
    }
    unsavedForm = false;
  });

  $("body").on("change", "input,textarea", function(event) {
    unsavedForm = true;
  });

  window.addEventListener("beforeunload", function(event) {
    if(unsavedForm) {
      event.returnValue = "Do you want to leave this page? Changes you have made may not be saved."
    }
  }); 
});
