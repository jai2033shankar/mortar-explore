$.mortar_data = $.mortar_data || {};
$.mortar_data.widgets = $.mortar_data.widgets || {};


/*
 * Fills in a table using the contents of the array
 *      table_header -- selector for <thead>
 *      table_body -- selector for <tbody>
 *      array -- array containing objects.  keys are required for proper iteration
 */
$.mortar_data.widgets.draw_table = function(table_header, table_body, array){
  var key_array = [];
  if(array.length > 0){
    $(table_header).empty();
    $(table_body).empty();

    $(table_header).append('<tr></tr>');
    for(key in array[0]){
      key_array.push(key);
      $(table_header + ' tr').append('<th>' + key + '</th>'); 
    }

    for(var i  = 0; i < array.length; i++){
      
      var row = array[i];
      var $table_row = $(table_body).append('<tr></tr>'); 
      key_array.forEach(function(key){
        $table_row.append('<td>' + row[key] + '</td>');
      });
    }
  }


}
