var client = new Client();
var dom = new Dom();

addField = function(element, content) {
  $(element).append($(content).html());
};

assignIds = function(element, id_prefix) {
  $(element).each(function(i) {
    $(this).attr("id", id_prefix + i)
  });
};

removeElement = function(id_prefix, index) {
  $(id_prefix + index).remove();
};

getIdIndex = function(element, id_prefix) {
  var id = $(element).attr("id")
  return id.replace(id_prefix, "");
};

isLastFieldBlank = function(element) {
  if($(element).last().val()) {
    return true;
  } else {
    return false;
  }
}
