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
       
      expect($(".element#my_prefix_0").length).toEqual(1);
      expect($(".element#my_prefix_1").length).toEqual(1);
      expect($(".element#my_prefix_2").length).toEqual(0);

    });
  });

  describe("removeElement()", function() {
    it("removes an element from the DOM", function() {
      affix(".element#my_prefix_1");
      removeElement("#my_prefix_", 1);
      
      expect($(".element#my_prefix_1").length).toEqual(0); 
    });
  });

  describe("getIdIndex()", function() {
    it("gets the index from an element's id", function() {
      affix(".element#my_prefix_200");
      var index = getIdIndex(".element", "my_prefix_");

      expect(index).toEqual("200");
    });
  });


  describe("isFieldBlank()", function() {
    it("returns true if any field is blank", function() {
      affix("input[value='something'].element")
      affix("input[value=' '].element")
      affix("input[value='something'].element")

      expect(isFieldBlank(".element")).toEqual(true);
    });

   it("returns false if fields are not blank", function() {
      affix("input[value='or'].element")
      affix("input[value='something'].element")
      affix("input[value='else'].element")

      expect(isFieldBlank(".element")).toEqual(false);
    });
  });
});
