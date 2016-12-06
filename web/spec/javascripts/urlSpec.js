//= require application

describe("Url", function() {
  var url; 
  beforeEach(function() {
    var server = sinon.fakeServer.create();
    url = new Url();
  });
  
  describe("getIdFromURI()", function() {
    it("should return the parent id", function() {
      var uri = "/projects/3"
      expect(url.getIdFromURI(uri)).toEqual(3)
    });
  });

  describe("redirectToURI()", function() {
    it("should redirect to a new page", function() {
      spyOn(url, "redirectToURI").and.returnValue(1);
      var redirect = url.redirectToURI("/new");
      expect(url.redirectToURI).toHaveBeenCalled();
      expect(redirect).toEqual(1); 
    });
  });
});
