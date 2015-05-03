(function(){
  $(document).ready(function(){
    var statsHandle;
    function navToStatsHandle(){
      var handle = statsHandle || $('.fgen-search').val();
      if (handle){
        statsHandle = null;
        document.location.href = '/stats/'+handle;
      } else {
        return false;
      }
    }
    $('.fgen-search').keyup(function(event){
      if (event.keyCode===13){
        setTimeout(function(){
          navToStatsHandle();
        }, 10);
      }
    });
    $('.fgen-search-submit').click(function(){
      navToStatsHandle();
      return false;
    });
    $('.fgen-search').keyup(function(){
      statsHandle = $('.typeahead li.active').data('value');
    });
    $('.typeahead li.active').click(function(){
      statsHandle = $('.typeahead li.active').data('value');
    });
    $('.fgen-search').typeahead({
      source: function (query, process) {
        return $.get('/search', { term: query }, function (data) {
          var options = [];
          data.options.forEach(function(opt){
            options.push(opt.split(':')[2]);
          });
          return process(options);
       });
     },
     items : 15
    });
  });
})();
