(function() {
  var vm;

  vm = {
    generatedCodes: new ko.observableArray(),
    generateNew: function() {
      var _this = this;
      return $.post('/generate', function(result) {
        return _this.generatedCodes.push({
          url: result.url
        });
      });
    }
  };

  ko.applyBindings(vm);

}).call(this);
