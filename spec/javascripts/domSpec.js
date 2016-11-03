//= require application

describe("Dom", function() {
  var dom;

  beforeEach(function() {
    dom = new Dom();
  });

  describe("displayPartial()", function() {
    it("can display HTML response in an element", function() {
      affix("#element");
      dom.displayPartial('#element', 'my partial');
      
      expect($('#element').html()).toEqual('my partial');
    });
  });

  describe("hideElement()", function() {
    it("can hide an element", function() {
      affix("#element");
      dom.hideElement('#element');

      expect($('#element').css('display')).toEqual('none');
    });
  });

  describe("replaceContent()", function() {
    it("empties the content of an element and appends new content", function() {
      affix("#element div span p");
      dom.replaceContent('#element', 'new content');
      
      expect($('#element').html()).toEqual('new content');
    });
  });
});
