$.mortar_data = $.mortar_data || {};
$.mortar_data.widgets = $.mortar_data.widgets || {};

function MortarTable(table_container_id, array, options){
  this.array = array;
  this.table_container_id = table_container_id;
  var now = new Date().getTime();
  this.table_id = 'table_' + now;
  this.table_header_id = 'table_' + now + '_header';
  this.table_body_id = 'table_' + now + '_body';
  this.table_class = options.table_class || 'table table-bordered table-condensed table-striped';

  return this;
};

MortarTable.prototype.erase = function(){
  $(this.table_container_id).empty();
};

MortarTable.prototype.draw = function(){
  this.erase();
  var array = this.array;
  var table_header = this.table_header_id;
  var table_body = this.table_body_id;
  var table_container = this.table_container_id; 
  var table_id = this.table_id;
  
  $(table_container).append(
      '<table id="' + table_id + '" class="' + this.table_class + '">'+
        '<thead id="' + table_header + '"></thead>'+
        '<tbody id="' + table_body + '"></tbody>'+
      '</table>'
    );
  this.draw_rows();
};


MortarTable.prototype.draw_rows = function(){
  var key_array = [];
  var array = this.array,
      table_header = '#' +this.table_header_id,
      table_body = '#'+this.table_body_id;
  debugger;
  if(array.length > 0){

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
};

/*
 * Fills in a table using the contents of the array
 *      table_header -- selector for <thead>
 *      table_body -- selector for <tbody>
 *      array -- array containing objects.  keys are required for proper iteration
 */
$.mortar_data.widgets.draw_table = function(table_header, table_body, array){
  var key_array = [];
  if(array.length > 0){
    $.mortar_data.widgets.erase_table(table_header, table_body);

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


};


$.mortar_data.widgets.erase_table = function(table_header, table_body){
  $(table_header).empty();
  $(table_body).empty();
};
