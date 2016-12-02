//= require application

describe("Alert", function() {
  var alert;

  beforeEach(function() {
    alerts = new Alert();
  });

  describe("alertController()", function() {
    it("returns true when condition is true", function() {
      condition = true;

      expect(alerts.alertController(condition)).toEqual(true);
    });

    it("returns undefined when unsavedForm is false", function() {
      condition = false;

      expect(alerts.alertController(condition)).toEqual(undefined);
    });
  });
});

