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
    },
    events: new ko.observableArray([
      {
        name: 'one'
      }, {
        name: 'two'
      }
    ])
  };

  ko.applyBindings(vm);

}).call(this);
