$.mortar_data = $.mortar_data || {};
$.mortar_data.widgets = $.mortar_data.widgets || {};

/*
 * Initialize with
 * var mortarTable = new MortarTable(
 *      table_container_id: id of div,
 *      array: [{}, {}...],
 *      options: {
 *          page_limit: how many items before next page,
 *          table_class: custom class for table,
 *          next_callback: event handler for clicking next page,
 *          previous_callback: event hanlder for clicking previous page
 *      }
 */
function MortarTable(table_container_id, array, options){
  this.set_array(array);
  this.table_container_id = table_container_id;
  var now = new Date().getTime();
  this.table_id = 'table_' + now;
  this.table_header_id = 'table_' + now + '_header';
  this.table_body_id = 'table_' + now + '_body';
  this.next_page_class = 'table_'+ now + '_next_page';
  this.previous_page_class = 'table_'+ now + '_previous_page';
  

  this.table_class = options.table_class || 'table table-bordered table-condensed table-striped';
  this.page_limit = options.page_limit || 10;
  this.index = 0;
  console.log(options);
  this.fire_next_page_finish = options.fire_next_page || null;
  this.fire_previous_page_finish = options.fire_previous_page || null;

  return this;
};

MortarTable.prototype.erase = function(){
  $(this.table_container_id).empty();
};

MortarTable.prototype.erase_rows = function(){
  $('#'+this.table_body_id).empty();
};


MortarTable.prototype.draw_body_content = function(){
  var key_array = this.key_array;
  var row_count = 0;
  for(var i  = this.index; i < this.array.length && row_count < this.page_limit; i++, row_count++){
    
    var row = this.array[i];
    var $table_row = $('#' + this.table_body_id).append('<tr></tr>'); 
    for( var j = 0; j < key_array.length; j++){
      $table_row.append('<td>' + row[key_array[j] ] + '</td>');
    }
  }
  this.index += row_count;
};

MortarTable.prototype.draw = function(){
  
  var array = this.array;
  var table_header = this.table_header_id;
  var table_body = this.table_body_id;
  var table_container = this.table_container_id; 
  var table_id = this.table_id;
  if(this.index == 0){ /* Drawing from brand new array */ 
    this.erase();
    $(table_container).append(
        '<div class="pagination pagination-right">'+
          '<ul>'+
            '<li><button id="" class="btn '+ this.previous_page_class +'">&larr;</button></li>'+
            '<li><button id="" class="btn '+ this.next_page_class + '" >&rarr;</button></li>'+
         ' </ul>'+
        '</div>'+
        '<table id="' + table_id + '" class="' + this.table_class + '">'+
          '<thead id="' + table_header + '"></thead>'+
          '<tbody id="' + table_body + '"></tbody>'+
        '</table>'+
        '<div class="pagination pagination-right">'+
          '<ul>'+
            '<li><button id="" class="btn '+ this.previous_page_class +'">&larr;</button></li>'+
            '<li><button id="" class="btn '+ this.next_page_class + '" >&rarr;</button></li>'+
         ' </ul>'+
        '</div>'
    );
    var that = this;
    $('.'+this.next_page_class).click(function(){ /* Hack because we lose reference to this */
      if (that.index >= that.array.length){
        if(that.fire_next_page_finish) that.fire_next_page_finish();  
      }else{
        that.erase_rows();
        that.draw_body_content();
      }
   
    });
    $('.'+this.previous_page_class).click(function(){
      if(that.index == 0 || that.index-(that.page_limit*2) < 0 ){
        if(that.fire_previous_page_finish) that.fire_previous_page_finish(); 
      }else{
        that.index -= that.page_limit*2;
        that.erase_rows();
        that.draw_body_content();
      }
    });

   

  }
  this.draw_rows();
};


MortarTable.prototype.draw_rows = function(){
  var array = this.array,
      key_array = this.key_array,
      table_header = '#' +this.table_header_id,
      table_body = '#'+this.table_body_id;
  if(array.length > 0){

    $(table_header).append('<tr></tr>');
    for(var key = 0; key <  key_array.length; key++){
      $(table_header + ' tr').append('<th>' + key_array[key] + '</th>'); 
    }
    this.draw_body_content();
    
  }
};

MortarTable.prototype.keys = function(hash){
  var keys = [];
  for(var i in hash) if (hash.hasOwnProperty(i)){
    keys.push(i);
  }
  console.log(keys);
  return keys;
}

MortarTable.prototype.set_array = function(array){
  this.array = array;
  this.index = 0;
  this.key_array = [];
  if(this.array.length > 0){
    var k = this.keys(this.array[0]);
    for(var i = 0; i < k.length; i++){
      var key_item = k[i];
      console.log(key_item);
      this.key_array.push(key_item);
    }
  }
}

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
