(function(){
  /*  Controller Functions */
  function init_page(){
    window.onhashchange = function(e) {
      on_hash_change();
    };
    if (window.location.hash == ''){
      window.location.hash = '#browse';
    }
    on_hash_change();
  };


  /*  Event Handlers */
  function on_hash_change(){
    $('#explore_nav li').removeClass('active');
    $('.explore_content').addClass('hidden');
    var hash = window.location.hash;
    if (hash.search('/')>0){
      $('#detail_item').addClass('active');
      $('#detail_content').removeClass('hidden'); 
      $.mortar_data.details_view.init();
    }else{
      if(hash === '#browse' && !$.mortar_data.browse_view.is_rendered()){
        $.mortar_data.browse_view.init();
      }else if(hash === '#search'){
        $.mortar_data.search_view.init();
      }
      $(hash + '_item').addClass('active');  
      $(hash + '_content').removeClass('hidden');
    };
  };

  $(document).ready(function()  {
    init_page();
  });


})();
