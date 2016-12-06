function Project() {
  var client = new Client();
  var dom = new Dom();
};

Project.prototype.validateFields = function(anEvent, element, message) {
  if(dom.isFieldBlank(element)) {
    anEvent.preventDefault();
    dom.replaceContent(".alert-error", message);
  };
};

Project.prototype.assignInviteIds = function() {
  dom.assignIds(".remove-invite-link", "remove_invite_");
  dom.assignIds("#invites .form-input", "input_");
};

Project.prototype.removeInviteField = function(element) {
  var index = dom.getIdIndex(element, "remove_invite_");
  dom.removeElement("#input_", index);
  dom.removeElement("#remove_invite_", index);
};

Project.prototype.addInviteField = function() {
  dom.unhideElement(".remove-invite-link");
  dom.addContent("#invites", "#new-invite-field");
  this.assignInviteIds();
};
