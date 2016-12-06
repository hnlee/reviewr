//= require application

describe("Dom", function() {
  var dom;

  beforeEach(function() {
    dom = new Dom();
  });

  describe("displayPartial()", function() {
    it("can display HTML response in an element", function() {
      affix("#element");
      dom.displayPartial("#element", "my partial");
      
      expect($("#element").html()).toEqual("my partial");
    });
  });

  describe("hideElement()", function() {
    it("can hide an element", function() {
      affix("#element");
      dom.hideElement("#element");

      expect($("#element").css("display")).toEqual("none");
    });
  });

  describe("replaceContent()", function() {
    it("empties the content of an element and appends new content", function() {
      affix("#element div span p");
      dom.replaceContent("#element", "new content");
      
      expect($("#element").html()).toEqual("new content");
    });
  });

  describe("unhideElement()", function() {
    it("can make a hidden element visible", function() {
      affix("#element[style='display:none']")
      dom.unhideElement("#element")

      expect($('#element').css('display')).toEqual('inline');
    });
  });

  describe("assignIds()", function() {
    it("creates a numbered element id", function() {
      affix(".element");
      affix(".element");
      dom.assignIds(".element", "my_prefix_");
       
      expect($(".element#my_prefix_0").length).toEqual(1);
      expect($(".element#my_prefix_1").length).toEqual(1);
      expect($(".element#my_prefix_2").length).toEqual(0);
    });
  });

  describe("addContent()", function() {
    it("adds content to an element", function() {
      affix("#element");
      affix("#content #new-content");
      dom.addContent("#element", "#content"); 
       
      expect($("#element").html()).toEqual('<div id="new-content"></div>');
    });
  });

  describe("removeElement()", function() {
    it("removes an element from the DOM", function() {
      affix(".element#my_prefix_1");
      dom.removeElement("#my_prefix_", 1);
      
      expect($(".element#my_prefix_1").length).toEqual(0); 
    });
  });

  describe("getIdIndex()", function() {
    it("gets the index from an element's id", function() {
      affix(".element#my_prefix_200");
      var index = dom.getIdIndex(".element", "my_prefix_");

      expect(index).toEqual("200");
    });
  });


  describe("isFieldBlank()", function() {
    it("returns true if any field is blank", function() {
      affix("input[value='something'].element")
      affix("input[value=' '].element")
      affix("input[value='something'].element")

      expect(dom.isFieldBlank(".element")).toEqual(true);
    });

   it("returns false if fields are not blank", function() {
      affix("input[value='or'].element")
      affix("input[value='something'].element")
      affix("input[value='else'].element")

      expect(dom.isFieldBlank(".element")).toEqual(false);
    });
  });
});
