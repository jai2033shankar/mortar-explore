(function(){
  function init_search(){
    $('#search_button').on('click', fire_search);  
  };

  function load_search(data){
    console.log(data);   
  };
  
  function search_error(data){
  
  };

  function fire_search(){
    var search_field = $('#search_query').val();
    $.mortar_data.api.get_search(search_field, load_search, search_error);
  }

  $(document).ready(function(){
    init_search(); 
  });
})();
