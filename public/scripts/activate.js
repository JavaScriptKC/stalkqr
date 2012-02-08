(function() {

  $(function() {
    return $('#activate').click(function() {
      console.log($(this).data('id'));
      return $.post('/activate/' + $(this).data('id').toString(), function(res) {
        if (res.result) return $('#activationSuccess').fadeIn();
      });
    });
  });

}).call(this);
