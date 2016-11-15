//= require application

describe("Reviews", function() {
  beforeEach(function() { 
    server = sinon.fakeServer.create();
  });

  describe("showNewReviewForm()", function() {
    it("loads new review form and hides container for link to new review", function() {
      affix("#new-review");
      affix("#new-review-link");
      server.respondWith("GET",
                         "/reviews/new/1",
                         "form html");
      showNewReviewForm(1);
      server.respond();

      expect($("#new-review").html()).toEqual("form html");
      expect($("#new-review-link").css("display")).toEqual("none");
    });
  });

  describe("submitNewReviewForm()", function() {
    it("submits the new review and replaces the form with it", function() {
      var callback = sinon.spy();
      server.respondWith("POST",
                         "/reviews/new/1",
                         "new review");
      submitNewReviewForm(1, callback);
      server.respond();

      expect(callback.called).toEqual(true);
    });
  });

  describe("showEditReviewForm()", function() {
    it("loads the edit review form and hides the edit icon and the review content", function() {
      affix("#page-title");
      affix("#edit-review");
      affix("#edit-review-link");
      affix("#review-content");
      server.respondWith("GET",
                         "/reviews/1/edit",
                         "form html");
      showEditReviewForm(1);
      server.respond();
      
      expect($("#edit-review").html()).toEqual("form html");
      expect($("#edit-review-link").css("display")).toEqual("none");
      expect($("#review-content").css("display")).toEqual("none");
      expect($("#page-title").html()).toEqual("Update review");
    });
  });

  describe("submitEditReviewForm()", function() {
    it("submits the edited review and replaces the edit review form with it", function() {
      var callback = sinon.spy();
      server.respondWith("POST",
                         "/reviews/1/edit",
                         "edited review");
      submitEditReviewForm(1, callback);
      server.respond();

      expect(callback.called).toEqual(true);
    });
  });

  afterEach(function() {
    server.restore(); 
  });
});


