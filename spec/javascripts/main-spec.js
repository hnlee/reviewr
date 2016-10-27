//= require application

describe("get project id from uri", function() {
  it("should return the project id", function() {
    var uri = "/projects/3"
    expect(getProjectIdFromURI(uri)).toEqual(3)
  });
});