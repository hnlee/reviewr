function Dom() {
}

Dom.prototype.displayPartial = function(element, partial) {
  $(element).html(partial); 
};

Dom.prototype.hideElement = function(element) {
  $(element).css("display", "none");
};

Dom.prototype.replaceContent = function(element, content) {
  $(element).empty().append(content);
};

Dom.prototype.unhideElement = function(element) {
  $(element).css('display', 'inline');
};

Dom.prototype.addContent = function(element, content) {
  $(element).append($(content).html());
};

Dom.prototype.assignIds = function(element, id_prefix) {
  $(element).each(function(i) {
    $(this).attr("id", id_prefix + i)
  });
};

Dom.prototype.removeElement = function(id_prefix, index) {
  $(id_prefix + index).remove();
};

Dom.prototype.getIdIndex = function(element, id_prefix) {
  var id = $(element).attr("id")
  return id.replace(id_prefix, "");
};

Dom.prototype.isFieldBlank = function(element) {
  var blank = false;
  $(element).each(function() {
    if($(this).val().trim().length == 0) {
      blank = true;
    }
  });
  return blank;
};


