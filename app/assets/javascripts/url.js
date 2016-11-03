function Url() {
}

Url.prototype.getIdFromURI = function(uri) {
  var pageURI = decodeURI(uri);
  var splitURI = pageURI.split("/");
  var id = splitURI[splitURI.length - 1];
  return parseInt(id);
};

Url.prototype.redirectToURI = function(uri) {
  window.location.replace(uri)
};

