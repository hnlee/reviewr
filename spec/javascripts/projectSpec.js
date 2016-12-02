//= require application

describe("Projects", function() {
  beforeEach(function() {
    project = new Project();
    server = sinon.fakeServer.create();
  });

  describe("addInviteField()", function() {
    it("adds an invite field", function() {
      affix("a.remove-invite-link[style='display:none']#remove_invite_0");
      affix("#invites .form-input#input_0");
      newField = affix("#new-invite-field[style='display:none']");
      newField.affix(".form-input");
      newField.affix("a.remove-invite-link");
      addSpy = sinon.spy(dom, "addContent");
      assignSpy = sinon.spy(project, "assignInviteIds");
      project.addInviteField();

      expect(addSpy.called).toBe(true); 
      expect(assignSpy.called).toBe(true); 
      expect($("#remove_invite_0").is(":visible")).toBe(true);
    });
  });

  describe("removeInviteField()", function() {
    it("removes the invite field with the given index", function() {
      affix("#input_0");
      affix(".element#remove_invite_0");
      var spy = sinon.spy(dom, "removeElement");
      project.removeInviteField(".element");

      expect(spy.calledTwice).toEqual(true);
    });
  });

  describe("assignInviteIds()", function() {
    it("assigns ids to .form-input and .remove-invite-link", function() {
      affix("#invites .form-input");
      affix(".remove-invite-link")
      project.assignInviteIds();

      expect($("#input_0").length).toBe(1);
      expect($("#remove_invite_0").length).toBe(1); 
    });
  });

  describe("validateFields()", function() {
    it("shows error message if a input field is blank", function() {
      affix(".alert-error")
      affix("input[value=' '].element")
      anEvent = new Event("click");
      project.validateFields(anEvent, ".element", "message");
    
      expect($(".alert-error").html()).toEqual("message")
    });
  });

});
