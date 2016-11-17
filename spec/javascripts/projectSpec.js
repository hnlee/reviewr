//= require application

describe("Projects", function() {
  beforeEach(function() {
    server = sinon.fakeServer.create();
  });

  describe("addField()", function() {
    it("loads a new email field to invite a reviewer", function() {
      affix("#invites");
      affix("#new-invite-field div#content");
      addField("#invites", "#new-invite-field"); 
       
      expect($("#invites").html()).toEqual('<div id="content"></div>');
    });
  });

  describe("assignIds()", function() {
    it("creates a numbered element id", function() {
      affix(".element");
      affix(".element");
      assignIds(".element", "my_prefix_");
       
      expect($('.element#my_prefix_0').length).toEqual(1);
      expect($('.element#my_prefix_1').length).toEqual(1);
      expect($('.element#my_prefix_2').length).toEqual(0);

    });
  });


  describe("removeElement()", function() {
    it("removes an element from the DOM", function() {
      affix(".element#my_prefix_1");
      removeElement("#my_prefix_", 1);
      
      expect($('.element#my_prefix_1').length).toEqual(0); 
    });
  });

  describe("getIdIndex()", function() {
    it("gets the index from an element's id", function() {
      affix(".element#my_prefix_200");
      var index = getIdIndex(".element", "my_prefix_");

      expect(index).toEqual('200');
    });
  });

  describe("assignMinusIds()", function() {
    it("creates a numbered element id", function() {
      affix("#invites");
      addInviteField();
      addInviteField();
      assignMinusIds();
       
      expect($("#invites .remove-invite-link:eq(0)").attr("id")).toEqual("remove_invite_0");
      expect($("#invites .remove-invite-link:eq(1)").attr("id")).toEqual("remove_invite_1");
    });
  });

    describe("assignInviteFieldIds()", function() {
    it("creates a numbered element id", function() {
      affix("#invites");
      addInviteField();
      addInviteField();
      assignInviteFieldIds();
       
      expect($("#invites .form-input:eq(0)").attr("id")).toEqual("input_0");
      expect($("#invites .form-input:eq(1)").attr("id")).toEqual("input_1");
    });
  });
});
