(function(){
  /*  Controller Functions */
  function init_browse(){
    get_browse_results(100, 1, '', reload_table);  
  }

  function reload_table(data){
    var data_parsed = JSON.parse(data);
    $.mortar_data.widgets.draw_table('#browse_table_header', '#browse_table_body', data_parsed.item_item_recs);
  }

  function get_browse_by(){
    return 50; 
  }
  function get_browse_results(quantity, index, directory, success_callback){
    var params = {
      quantity  : quantity,
      index     : index,
      directory : directory
    }
    $.ajax({
      url: '/api/v1/browse',
      data:params,
      success: success_callback 
    }); 
  }

  $(document).ready(function()  {
      init_browse(); 
  });


})();

