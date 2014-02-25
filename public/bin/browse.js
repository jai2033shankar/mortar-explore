(function(){
  /*  Controller Functions */
  function init_browse(){
     
  }

  function reload_table(){
  
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
       
  });


})();

