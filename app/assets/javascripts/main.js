var unsavedForm;

onReady = function () {
  url = new Url();
  dom = new Dom();
  client = new Client();
  review = new Review();
  rating = new Rating();
  project = new Project();
  tab = new Tab();
  alerts = new Alert();

  var path_id = url.getIdFromURI(window.location.pathname);

  tabHandler(tab); 
  
  projectFormHandler(project);

  ratingFormHandler(path_id, rating);

  reviewFormHandler(path_id, review);

  unsavedFormHandler(alerts);
};

tabHandler = function(tab) {
  tab.showActiveTabContents(".tab-content", "#projects");

  $(".tab-container").on("click", "li", function(event) {
    event.preventDefault();
    var active_content_id = $("a", this).attr("href");

    tab.deactivateTab("li.active");
    tab.activateTab(this);

    tab.showActiveTabContents(".tab-content",
                              active_content_id);
  });
};

projectFormHandler = function(project) {
  project.assignInviteIds();

  $("#add-invite-link").on("click", function(event) {
    event.preventDefault();
    project.addInviteField();
    
    $(".remove-invite-link").on("click", function(event) {
      project.removeInviteField(this);
    });
  });

  $(".remove-invite-link").on("click", function(event) {
    project.removeInviteField(this);
  });

  var inviteErrorMessage = "<p>Please input an email address</p><br />" 

  $("#submit-project-button").on("click", function(event) {
    project.validateFields(event, "#invites .form-input", inviteErrorMessage)
  });

  $("#edit-project-button").on("click", function(event) {
    project.validateFields(event, "#invites .form-input", inviteErrorMessage)
  });
};

ratingFormHandler = function(path_id, rating) {
  $("#random-rating-up").on("click", function(event) {
    event.preventDefault();
    var review_id = $(this).parent().attr('data-id');
    rating.showRandomRatingForm(review_id, path_id, true);
    unsavedForm = true;
  });

  $("#random-rating-down").on("click", function(event) {
    event.preventDefault();
    var review_id = $(this).parent().attr('data-id');
    rating.showRandomRatingForm(review_id, path_id, false);
    unsavedForm = true;
  });

  $("#new-rating-up").on("click", function(event) {
    event.preventDefault();
    rating.showNewRatingForm(path_id, true);
    unsavedForm = true;
  });

  $("#new-rating-down").on("click", function(event) {
    event.preventDefault();
    rating.showNewRatingForm(path_id, false);
    unsavedForm = true;
  });

  $("#submit-rating-button").on("click", function(event) {
     event.preventDefault();
     rating.submitNewRatingForm(path_id);
  });
};

reviewFormHandler = function(path_id, review) {
  $("#new-review-link").on("click", function(event) {
    event.preventDefault();
    review.showNewReviewForm(path_id);
  });

  $("#submit-review-button").on("click", function(event) {
    event.preventDefault();
    review.submitNewReviewForm(path_id);
  });

  $("#edit-review-link").on("click", function(event) {
    event.preventDefault();
    review.showEditReviewForm(path_id);
  });

  $("#edit-review-button").on("click", function(event) {
    event.preventDefault();
    review.submitEditReviewForm(path_id);
  });
};

unsavedFormHandler = function(alerts) {
  $("body").on("change", "input:not(:submit),textarea", function(event) {
    unsavedForm = true;
  });

  $("body").on("click", "input:submit", function(event) {
    unsavedForm = false;
  });

  $(window).on("beforeunload", function(event) {
    return alerts.alertController(unsavedForm);
  });
};

$(document).ready(onReady);
