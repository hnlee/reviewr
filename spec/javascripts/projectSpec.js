//= require application

describe("Projects", function() {
  beforeEach(function() {
    server = sinon.fakeServer.create();
  });

  describe("addInviteField()", function() {
    it("loads a new email field to invite a reviewer", function() {
      affix("#invites");
      addInviteField(); 
       
      expect($("#invites").html()).toEqual('<input type="email" name="invites[email]">');
    });
  });
});
