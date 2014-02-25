(function(){
  /*  Controller Functions */
  function init_page(){
    window.onhashchange = function(e) {
      on_hash_change();
    };
    on_hash_change();
  };


  /*  Event Handlers */
  function on_hash_change(){
    $('#explore_nav li').removeClass('active');
    $('.explore_content').addClass('hidden');
    var hash = window.location.hash;
    $(hash + '_item').addClass('active');  
    $(hash + '_content').removeClass('hidden');
  };

  $(document).ready(function()  {
    init_page();
  });


})();

