function MockClient() {
  this.requestMade = false;
}

MockClient.prototype.showNewReviewForm = function(project_id) {
  this.requestMade = true;
};