//= require application

describe("Tab", function() {
  var tab;

  beforeEach(function() {
    tab = new Tab();
  });

  describe("activateTab()", function() {
    it("adds active class to given tab element", function() {
      affix("li");
      tab.activateTab("li");

      expect($("li").hasClass("active")).toEqual(true);
    });
  });

  describe("deactivateTab()", function() {
    it("removes active class from given tab element", function() {
      affix("li.active")
      tab.deactivateTab("li");

      expect($("li").hasClass("active")).toEqual(false);
    });
  });

  describe("showActiveTabContents()", function() {
    it("hides inactive tab contents and shows active tab contents", function() {
      affix(".tab-content#show-content div#show")
      affix(".tab-content#hide-content div#hide")
      tab.showActiveTabContents(".tab-content", "#show-content");

      expect($("div#show").is(":visible")).toEqual(true);
      expect($("div#hide").is(":visible")).toEqual(false);
    });
  });
});

