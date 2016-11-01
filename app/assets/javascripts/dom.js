function Dom() {
}

Dom.prototype.displayPartial = function(element, partial) {
  $(element).html(partial); 
};

Dom.prototype.hideElement = function(element) {
  $(element).css('display', 'none');
};

Dom.prototype.replaceContent = function(element, content) {
  $(element).empty().append(content);
};
