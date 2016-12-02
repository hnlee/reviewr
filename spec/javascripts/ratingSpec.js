//= require application

describe("Ratings", function() {
  beforeEach(function() {
    server = sinon.fakeServer.create();
    rating = new Rating();
  });

  describe("showRatingForm()", function() {
    it("loads new rating form and hides container for link to new rating and text about rating criteria", function() {
      affix("#new-rating");
      affix("#new-rating-box"); 
      affix("#rating-criteria");
      server.respondWith("GET",
                         "/ratings/new/1",
                         "form html");
      rating.showRatingForm(1, "");
      server.respond();

      expect($("#new-rating").html()).toEqual("form html");
      expect($("#new-rating-box").css("display")).toEqual("none");
      expect($("#rating-criteria").css("display")).toEqual("none");
    });
  });

  describe("addThumbParam()", function() {
    it("returns empty string if no thumb boolean", function() {
      expect(rating.addThumbParam()).toEqual("");
    });
    it("takes a thumb=true boolean and creates URL parameter", function() {
      var thumb = true;

      expect(rating.addThumbParam(thumb)).toEqual("?thumb=up");
    });
    it("takes a thumb=false boolean and creates URL parameter", function() {
      var thumb = false;

      expect(rating.addThumbParam(thumb)).toEqual("?thumb=down");
    });
  });

  describe("showNewRatingForm()", function() {  
    it("loads new rating form with thumb parameter", function() {
      affix("#new-rating");
      affix("#new-rating-box"); 
      affix("#rating-criteria");
      server.respondWith("GET",
                         "/ratings/new/1?thumb=up",
                         "thumb up form");
      rating.showNewRatingForm(1, true);
      server.respond();

      expect($("#new-rating").html()).toEqual("thumb up form");
    });
  });

  describe("submitNewRatingForm()", function() {
    it("submits a new rating and replaces the form with it", function() {
      var callback = sinon.spy();
      server.respondWith("POST",
                         "/ratings/new/1",
                         "new rating");
      rating.submitNewRatingForm(1, callback);
      server.respond();

      expect(callback.called).toEqual(true);
    });
  });

  describe("showRandomRatingForm()", function() {
    it("loads random rating form and adds random=true boolean to the URL parameter", function() {
      affix("#new-rating");
      affix("#new-rating-box"); 
      affix("#rating-criteria");
      server.respondWith("GET",
                         "/ratings/new/1?thumb=up&random=true&user=1",
                         "form html");
      rating.showRandomRatingForm(1, 1, true);
      server.respond();

      expect($("#new-rating").html()).toEqual("form html");
      expect($("#new-rating-box").css("display")).toEqual("none");
      expect($("#rating-criteria").css("display")).toEqual("none");
    });
  })

  afterEach(function() {
    server.restore();
  });
});
