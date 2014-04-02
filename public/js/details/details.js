$.mortar_data = $.mortar_data || {};
$.mortar_data.details_view = $.mortar_data.details_view || {};



(function () {
  $.mortar_data.details_view.init = function(){
    init_details();
    
  }; 
  function init_details(){
    get_recommend(); 
    set_img_url(IMAGE_URL);
    set_item_url(ITEM_URL);
    set_img_src('#item_img', generate_item_img_src());
    set_breadcrumbs();
    $('#update_url').click(fire_update_url);
  };

    /*
   * Api call to get recommendations for specific query
   */
  function get_recommend(){
    $.mortar_data.api.get_recommend(       
      get_query(),
      '',
      fire_show_details,
      fire_detail_error
    );
  };
  
  function set_breadcrumbs(){
    $('#detail_base').empty();
    var base = get_base_hash();
    base = base.substr(1, base.length);
    $('#detail_base').append('<a href="' + get_base_hash() + '">' + $.mortar_data.util.capitalize_first_letter(base) + '</a>'); 
    $('#detail_id').text(get_query());

  };

  function set_item_src(){
    var item_url = get_item_url().replace('#{id}', get_query());
    $('#item_link').attr('href', item_url);
    $('#item_link_text').text(item_url);
    return item_url;
  };  

  function set_img_src(item_id, item_img_src){
    IMAGE_URL = get_img_url();
    ITEM_URL = get_item_url();
    $(item_id).attr('src',item_img_src.replace(' ', '-')); 
    $('#item_id_text').text(get_query());
    $('#recommendation_list img').each(function(index, item){
      var item_id = $(item).attr('data');
      $(item).attr('src', generate_img_url(item_id).replace(' ', '-')); 
    
    });
    $('#image_link_text').text(item_img_src);
    return item_img_src;
  };


  /*
   * sets image url text box
   */
  function set_img_url(url){
    $('#image_url').val(url);
  };

  function set_item_url(url){
    $('#item_url').val(url);
  };

  function get_img_url(){
    return $('#image_url').val();
  };

  function get_item_url(){
    return $('#item_url').val();
  };
  
  function generate_item_img_src(){
    return get_img_url().replace('#{id}', get_query());
  };

   /*
   * Url getters
   */
  function get_query(){
    var hash = window.location.hash;
    return hash.substr(hash.search('/') +1 , hash.length);
  };

  function get_base_hash(){
    var hash = window.location.hash; 
    return hash.substr(0, hash.search('/'));
  };

  function generate_img_url(id){
    return get_img_url().replace('#{id}', id);
  };



  /*
  * Event Handlers
  */
  function fire_show_details(data){
    var data = JSON.parse(data);
    generate_recommendation_list(data.item_item_recs);
    console.log(data);
  };

  function fire_detail_error(error_message){
  };
 
  /*
   * Handler for clicking update button
   */ 
  function fire_update_url(){
    var image_url = set_img_src('#item_img', generate_item_img_src()); 
    var item_url = set_item_src();
    debugger;
    $.mortar_data.api.put_url_config(get_img_url(), get_item_url());
  };


  function generate_recommendation_list(recommendations){
    $('#recommendation_list').empty();
    for(var i=0; i < recommendations.length; i++){
      var item = recommendations[i]; 
      var span_size = 2;// relative to span12 on bootstrap
      debugger;
      $('#recommendation_list').append(
        '<li class="span' + span_size + '">' + 
          '<div class="well">' + 
            '<a class="thumbnail"  href="'+ get_base_hash() + '/'+ item.item_B + '">'+
              '<img class="img-polaroid recommendation_image" src="' + get_img_url().replace('#{id}', item.item_B)+'" data="'+ item.item_B + '"></img>'+
            '</a>' +
            '<h2 class="center">Rank: ' + item.rank + '</h2>' +
            '<a class="center" target="_blank"  href="' + get_item_url().replace('#{id}', item.item_B) + '">To Item Page</a>'+
          '</div>'+
        '</li>'
      );

    };
  };

})();
