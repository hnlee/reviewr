//= require application

describe("Client", function() {
  var client;
  var server;

  beforeEach(function() {
    client = new Client();
    server = sinon.fakeServer.create();
  });
  
  describe("ajaxGet()", function() {
    it("can make ajax GET request", function() {
      server.respondWith("GET", 
                         "/", 
                         "success");
      var callback = sinon.spy();
      client.ajaxGet("/", callback);
      server.respond();

      expect(callback.called).toBe(true);
    });
  });

  describe("ajaxPost()", function() {
    it("can make ajax POST request", function() {
      server.respondWith("POST",
                         "/",
                         "success");
      var callback = sinon.spy();
      client.ajaxPost("/", callback);
      server.respond();

      expect(callback.called).toBe(true);
    });
  });

  afterEach(function() {
    server.restore();
  });
});
