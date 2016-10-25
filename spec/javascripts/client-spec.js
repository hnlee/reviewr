//= require application

describe("Client", function() {
  var client;
  var expectedHtml;

  it("can get html for a new review form", function() {
    var project_id = 1;
    var d = $.Deferred();
    d.resolve(1);

    spyOn($, 'ajax').and.returnValue(d.promise());

    var client = new Client();

    client.showNewReviewForm(client.getResponse, project_id);
    expect(client.response).toBe(1);
  });
});
