(function(){
  function init_search(){
    $('#search_button').on('click', fire_search);  
  };

  function load_search(data){
    console.log(data);
    var data_parsed = JSON.parse(data);

    $('#search_results').empty();
    if(data_parsed.error == null){
      for (key in data_parsed){
        var item = data_parsed[key];
        if(item instanceof Array){
          if(item.length>0){
            var header_id = 'search_' + key + '_table_header';
            var body_id = 'search_' + key + '_table_body';
            var table = '<table class="table table-bordered table-striped">' + 
                          '<thead id="' + header_id + '"></thead>' +
                          '<tbody id="' + body_id + '"></tbody>' +
                        '</table>';    
            $('#search_results').append(table);
            $.mortar_data.widgets.draw_table(
                        '#' + header_id,
                        '#' + body_id,
                        item
                    );
          }
        }
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
    $.mortar_data.api.get_search(search_field, load_search, search_error);
  }

  $(document).ready(function(){
    init_search(); 
  });
})();
