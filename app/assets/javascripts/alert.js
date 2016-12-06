function Alert() {
};

Alert.prototype.alertController = function(condition) {
  if(condition) {
    return true;
  } else {
    return undefined;
  }
};
