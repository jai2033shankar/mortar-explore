(function(){
  /*  Controller Functions */
  function init_browse(){
    $.mortar_data.api.get_browse(
          get_browse_by(), //quantity 
          1, //index to start browse
          '', //directory to browse by 
          reload_table,
          function(){
            console.log('error');
          }
      );  
  }
  
  /*
   * data - expect to be an object where each key leads to an array
   */
  function reload_table(data){
    var data_parsed = JSON.parse(data);
    var largest_array = []; //only one array will have content, so pick the largest
    var count = 0;
    for(key in data_parsed){
      var curr_array = data_parsed[key];
      if(curr_array.length > count){
        count  = curr_array.length;
        largest_array = curr_array;
      }
    }
    $.mortar_data.widgets.draw_table(
              '#browse_table_header', 
              '#browse_table_body', 
              largest_array
          );
  }

  function get_browse_by(){
    return 50; 
  }

  $(document).ready(function()  {
      init_browse(); 
  });


})();

