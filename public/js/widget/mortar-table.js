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
  now = now.toString() + Math.floor(Math.random()*1000).toString();
  this.table_id = 'table_' + now;
  this.table_header_id = 'table_' + now + '_header';
  this.table_body_id = 'table_' + now + '_body';
  this.next_page_class = 'table_'+ now + '_next_page';
  this.previous_page_class = 'table_'+ now + '_previous_page';
  

  this.table_class = options.table_class || 'table table-bordered table-condensed table-striped';
  this.page_limit = options.page_limit || 10;
  this.index = 0;
  this.fire_next_page_finish = options.next_callback || null;
  this.fire_previous_page_finish = options.previous_callback || null;
  this.clickable_column = options.clickable_column || null;
  this.detail_button = options.detail_button || null;

  return this;
};
/*
 * For resetting array
 */
MortarTable.prototype.set_array = function(array){
  this.array = array;
  this.index = 0;
  this.key_array = [];
  if(this.array.length > 0){
    var k = this.keys(this.array[0]);
    for(var i = 0; i < k.length; i++){
      var key_item = k[i];
      this.key_array.push(key_item);
    }
  }
}

/*
 * Main function to handle drawing.  Should really only need to call this
 */
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
    //$(this.table_id).tablesorter();
    /* Event handler for next page click */
    $('.'+this.next_page_class).click(function(){ /* Hack because we lose reference to this */
      if (that.index >= that.array.length){
        if(that.fire_next_page_finish) that.fire_next_page_finish();  
      }else{
        that.erase_rows();
        that.draw_body_content();
      }
   
    });
    /* Event handler for back page click */
    $('.'+this.previous_page_class).click(function(){
      if(that.index == 0 || that.index-(that.page_limit + that.row_count) < 0 ){
        if(that.fire_previous_page_finish) that.fire_previous_page_finish(); 
      }else{
        that.index -= (that.page_limit +that.row_count);
        
        that.erase_rows();
        that.draw_body_content();
      }
    });
  }
  this.draw_head_content();
};


/*
 * Erases Entire Table
 */
MortarTable.prototype.erase = function(){
  $(this.table_container_id).empty();
};

/*
 * Erases content rows
 */
MortarTable.prototype.erase_rows = function(){
  $('#'+this.table_body_id).empty();
};

/*
 * Only draws the body tag of the table using the header items as keys for array
 */
MortarTable.prototype.draw_body_content = function(){
  var key_array = this.key_array;
  var row_count = 0;
  for(var i  = this.index; i < this.array.length && row_count < this.page_limit; i++, row_count++){
    
    var row = this.array[i];
    var $table_row = $('#' + this.table_body_id).append('<tr></tr>'); 
    
    $table_row = $('#' + this.table_body_id + ' tr:last');
    if(this.detail_button){
      var link = encodeURI(row['column' + this.detail_button]);
      $table_row.append('<td class="flat-cell">' + 
          '<a class="btn btn-cell btn-primary" href="'+window.location.hash + '/' + link + '">Details</a></td>'
        ); 
    }
    for( var j = 0; j < key_array.length; j++){
      if (this.clickable_column == j){
        $table_row.append('<td><a  href="' + window.location.hash +'/'+ row[key_array[j]] + '">' + row[key_array[j] ] + '</a></td>');
      } else{
        $table_row.append('<td>' + row[key_array[j] ] + '</td>');
      }
    }
  }

  //$(this.table_id).trigger('update');
  this.index += row_count;
  this.row_count = row_count;
};

/*
 * Only draws the body tag of the table using the header items as keys for array
 */
MortarTable.prototype.draw_head_content = function(){
  var array = this.array,
      key_array = this.key_array,
      table_header = '#' +this.table_header_id,
      table_body = '#'+this.table_body_id;
  if(array.length > 0){
    
    $(table_header).append('<tr></tr>');
    var $header = $(table_header + ' tr');
    if (this.detail_button){
      $header.append('<th></th>'); 
    }
    for(var key = 0; key <  key_array.length; key++){
      $header.append('<th>' + key_array[key] + '</th>'); 
    }
    this.draw_body_content();
    
  }
};


/**
 * Hack to get keys
 */
MortarTable.prototype.keys = function(hash){
  var keys = [];
  for(var i in hash) if (hash.hasOwnProperty(i)){
    keys.push(i);
  }
  return keys;
}


