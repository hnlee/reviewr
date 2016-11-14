function Tab() {
}

Tab.prototype.activateTab = function(tab) {
  $(tab).addClass('active');
};

Tab.prototype.deactivateTab = function(tab) {
  $(tab).removeClass('active');
};

Tab.prototype.showActiveTabContents = function(tab_content, content_id) {
  $(tab_content).hide();
  $(tab_content + content_id).show();
};
