//= require application

describe("Main", function() {
  describe("unsavedFormHandler()", function() {
    beforeEach(function() {
      alerts = new Alert();
    });

    it("sets unsavedForm to true when an input field that is not a submit button is changed", function() {
      affix("input[type=text]#element");
      unsavedFormHandler(alerts);
      $("#element").val("content").trigger("change"); 

      expect(unsavedForm).toEqual(true);
    });

    it("sets unsavedForm to false when a submit button is clicked", function() {
      affix("input[type=submit]#element");
      unsavedFormHandler(alerts);
      $("#element").trigger("click");

      expect(unsavedForm).toEqual(false);
    });

    it("calls alertController before window is unloaded", function() {
      var spy = sinon.spy(alerts, "alertController"); 
      unsavedFormHandler(alerts);
      $(window).trigger("beforeunload");

      expect(spy.called).toEqual(true);
    });
  });

  describe("reviewFormHandler()", function() {
    beforeEach(function() {
      review = new Review();
    });

    it("calls showNewReviewForm() when #new-review-link is clicked", function() {
      affix("#new-review-link");
      reviewFormHandler(1, review);
      var spy = sinon.spy(review, "showNewReviewForm"); 
      $("#new-review-link").trigger("click");

      expect(spy.called).toBe(true);
    });

    it("calls submitNewReviewForm() when #submit-review-form is clicked", function() {
      affix("#submit-review-button");
      reviewFormHandler(1, review);
      var spy = sinon.spy(review, "submitNewReviewForm");
      $("#submit-review-button").trigger("click");

      expect(spy.called).toBe(true);
    });

    it("calls showEditReviewForm() when #edit-review-link is clicked", function() {
      affix("#edit-review-link");
      reviewFormHandler(1, review);
      var spy = sinon.spy(review, "showEditReviewForm");
      $("#edit-review-link").trigger("click");

      expect(spy.called).toBe(true);
    });

    it("calls submitEditReviewForm() when #edit-review-link is clicked", function() {
      affix("#edit-review-button");
      reviewFormHandler(1, review);
      var spy = sinon.spy(review, "submitEditReviewForm");
      $("#edit-review-button").trigger("click");

      expect(spy.called).toBe(true);
    });
  });

  describe("ratingFormHandler()", function() {
    beforeEach(function() {
      rating = new Rating();
    });

    it("calls showNewRatingForm() when #new-rating-up is clicked", function() {
      affix("#new-rating-up");
      ratingFormHandler(1, rating);
      var spy = sinon.spy(rating, "showNewRatingForm");
      $("#new-rating-up").trigger("click");

      expect(spy.called).toBe(true);
      expect(unsavedForm).toBe(true);
    });

    it("calls showNewRatingForm() when #new-rating-down is clicked", function() {
      affix("#new-rating-down");
      ratingFormHandler(1, rating);
      var spy = sinon.spy(rating, "showNewRatingForm");
      $("#new-rating-down").trigger("click");

      expect(spy.called).toBe(true);
      expect(unsavedForm).toBe(true);
    });

    it("calls submitNewRatingForm() when #submit-rating-button is clicked", function() {
      affix("#submit-rating-button");
      ratingFormHandler(1, rating);
      var spy = sinon.spy(rating, "submitNewRatingForm");
      $("#submit-rating-button").trigger("click");

      expect(spy.called).toBe(true);
    });  

    it("calls showRandomRatingForm() when #random-rating-up is clicked", function() {
      affix("#parent[data-id='1'] #random-rating-up");
      ratingFormHandler(1, rating);
      var spy = sinon.spy(rating, "showRandomRatingForm");
      $("#random-rating-up").trigger("click");

      expect(spy.called).toBe(true);
    });

    it("calls showRandomRatingForm() when #random-rating-down is clicked", function() {
      affix("#parent[data-id='1'] #random-rating-down");
      ratingFormHandler(1, rating);
      var spy = sinon.spy(rating, "showRandomRatingForm");
      $("#random-rating-down").trigger("click");

      expect(spy.called).toBe(true);
    });
  });

  describe("tabHandler()", function() {
    var spy;

    beforeEach(function() {
      tab = new Tab();
      affix(".tab-content#projects #projects-content")
      affix(".tab-content#reviews #reviews-content")
      spy = sinon.spy(tab, "showActiveTabContents");
    });

    it("sets active tab to #projects", function() {
      tabHandler(tab);
      
      expect(spy.called).toBe(true);
      expect($("#projects-content").is(":visible")).toEqual(true);
      expect($("#reviews-content").is(":visible")).toEqual(false);
    });

    it("changes active tab when tab link is clicked", function() {
      var tabs = affix(".tab-container ul")
      tabs.affix("li.active a[href='#projects']")
      tabs.affix("li#tab-link a[href='#reviews']")
      var activateSpy = sinon.spy(tab, "activateTab");
      var deactivateSpy = sinon.spy(tab, "deactivateTab");
      tabHandler(tab);
      $("#tab-link").trigger("click");

      expect(activateSpy.called).toBe(true);
      expect(deactivateSpy.called).toBe(true);
      expect(spy.calledTwice).toBe(true);
      expect($("#projects-content").is(":visible")).toEqual(false);
      expect($("#reviews-content").is(":visible")).toEqual(true);
    });
  });

  describe("projectFormHandler()", function() {
    beforeEach(function() {
      var project = new Project();
    });

    it("calls assignInviteIds()", function() {
      spy = sinon.spy(project, "assignInviteIds");
      projectFormHandler(project);  

      expect(spy.called).toBe(true);
    });

    it("adds invite field when #add-invite-link is clicked", function() {
      affix("#add-invite-link");
      spy = sinon.spy(project, "addInviteField");
      projectFormHandler(project);
      $("#add-invite-link").trigger("click");

      expect(spy.called).toBe(true);
    });

    it("removes invite field when .remove-invite-link is clicked", function() {
      affix(".remove-invite-link#remove_invite_0");
      spy = sinon.spy(project, "removeInviteField");
      projectFormHandler(project);
      $(".remove-invite-link").trigger("click");

      expect(spy.called).toBe(true);
    });

    it("validates invite fields when #submit-project-button is clicked", function() {
      affix("#submit-project-button");
      spy = sinon.spy(project, "validateFields")
      projectFormHandler(project);
      $("#submit-project-button").trigger("click");

      expect(spy.called).toBe(true);
    });

    it("validates invite fields when #edit-project-button is clicked", function() {
      affix("#edit-project-button");
      spy.reset();
      projectFormHandler(project);
      $("#edit-project-button").trigger("click");

      expect(spy.called).toBe(true);
    });
  });
});
