function Alert() {
};

Alert.prototype.alertController = function(condition) {
  console.log(condition);
  if(condition) {
    return true;
  } else {
    return undefined;
  }
};
