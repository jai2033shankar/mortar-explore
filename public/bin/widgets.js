$.mortar_data = $.mortar_data || {};
$.mortar_data.widgets = $.mortar_data.widgets || {};

$.mortar_data.widgets.draw_table = function(table_header, table_body, array){
  var key_array = [];
  if(array.length > 0){
    $(table_header).append('<tr></tr>');
    for(key in array[0]){
      key_array.push(key);
      $(table_header + ' tr').append('<th>' + key + '</th>'); 
    }
  }
}
