(function(){
  var search_tables =[];
  function init_search(){
    $('#search_button').on('click', fire_search);  
  };

  function load_search(data){
    console.log(data);
    var data_parsed = JSON.parse(data);

    $('#search_results').empty();
    search_tables = [];
    if(data_parsed.error == null){
      for (key in data_parsed){
        var item = data_parsed[key];
        if(item instanceof Array){
          if(item.length>0){
            var container_id = 'search_' + key+'_table';
            $('#search_results').append('<div id="'+container_id+'"></div>');
            search_tables.push( new MortarTable(
                    '#' + container_id,
                    item,
                    {}
                  ));
          }
        }
        
      } 
      for(var i = 0; i < search_tables.length; i++){
        debugger;
        search_tables[i].draw(); 
      }
    }else{
      fire_search_error(data_parsed.error); 
    }
  };
  
  function fire_search_error(error_message){
    $('#search_error_row').removeClass('hidden');
    $('#search_error').text(error_message);

  }; 
  
  function search_error(data){
     
  };

  function fire_search(){
    var search_field = $('#search_query').val();
    if (search_field != ''){
      $.mortar_data.api.get_search(search_field, load_search, search_error);
    }else{
      fire_search_error('No search query was given.  Please specify'); 
    }
    
  }

  $(document).ready(function(){
    init_search(); 
  });
})();
