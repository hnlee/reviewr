//= require application

describe("Ratings", function() {
  beforeEach(function() {
    server = sinon.fakeServer.create();
  });

  describe("showNewRatingForm()", function() {
    it("loads new rating form and hides container for link to new rating and text about rating criteria", function() {
      affix("#new-rating");
      affix("#new-rating-box"); 
      affix("#rating-criteria");
      server.respondWith("GET",
                         "/ratings/new/1",
                         "form html");
      showNewRatingForm(1);
      server.respond();

      expect($("#new-rating").html()).toEqual("form html");
      expect($("#new-rating-box").css("display")).toEqual("none");
      expect($("#rating-criteria").css("display")).toEqual("none");
    });
    
    it("takes a thumb=true boolean and adds it to the URL parameter", function() {
      affix("#new-rating");
      affix("#new-rating-box"); 
      affix("#rating-criteria");
      server.respondWith("GET",
                         "/ratings/new/1?thumb=up",
                         "thumb up form");
      showNewRatingForm(1, true);
      server.respond();

      expect($("#new-rating").html()).toEqual("thumb up form");
    });
    
    it("takes a thumb=false boolean and adds it to the URL parameter", function() {
      affix("#new-rating");
      affix("#new-rating-box"); 
      affix("#rating-criteria");
      server.respondWith("GET",
                         "/ratings/new/1?thumb=down",
                         "thumb down form");
      showNewRatingForm(1, false);
      server.respond();

      expect($("#new-rating").html()).toEqual("thumb down form");
    });
  });

  describe("submitNewRatingForm()", function() {
    it("submits a new rating and replaces the form with it", function() {
      var callback = sinon.spy();
      server.respondWith("POST",
                         "/ratings/new/1",
                         "new rating");
      submitNewRatingForm(1, callback);
      server.respond();

      expect(callback.called).toEqual(true);
    });
  });
});
