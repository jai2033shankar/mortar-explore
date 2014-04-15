$.mortar_data = $.mortar_data || {};
$.mortar_data.details_view = $.mortar_data.details_view || {};


(function () {
  $.mortar_data.details_view.init = function(){
    $('i').tooltip();
    init_details();
  }; 
  
  var recommendation_data = [];
  function init_details(){
    get_recommend(); 
    set_img_url(IMAGE_URL);
    set_item_url(ITEM_URL);
    set_breadcrumbs();
    $('#update_url').click(fire_update_url);
    //set_img_src('#item_img', generate_item_img_src());
    $('select').change(function(){
      fire_select_change(recommendation_data); 
    });
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
    var query = recommendation_data.length ? recommendation_data[0][get_item_select()] : get_query();
    var item_url = get_item_url().replace('#{id}', query);
    $('#item_link').attr('href', item_url);
    $('#item_link_text').text(item_url);
    return item_url;
  };  

  function set_img_src(item_id, item_img_src){
    var item_id = '#item_img';
    var item_img_src = generate_item_img_src();
    var query = recommendation_data.length ? recommendation_data[0][get_item_select()] : get_query();
    IMAGE_URL = get_img_url();
    ITEM_URL = get_item_url();
    $(item_id).attr('src', item_img_src); 
    $('#item_id_text').text(query);
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
    $('#itegm_url').val(url);
  };

  function set_item_select(val){
    $('#item_select').val(val); 
  };

  function set_recommendation_select(val){
    $('#recommendation_select').val(val); 
  };
  
  function set_rank_select(val){
    $('#rank_select').val(val);
  };


  /*
   * getters
   */
  function get_query(){
    var hash = decodeURI(window.location.hash);
    return hash.substr(hash.search('/') +1 , hash.length);
  };

  function get_base_hash(){
    var hash = window.location.hash; 
    return hash.substr(0, hash.search('/'));
  };


  function get_img_url(){
    return $('#image_url').val();
  };

  function get_item_url(){
    return $('#item_url').val();
  };

  function get_rank_select(){
    return $('#rank_select').val();
  };
  
  function get_recommendation_select(){
    return $('#recommendation_select').val();
  };

  function get_item_select(){
    return $('#item_select').val();
  };

  /*
   * Url Generators
   */
  function generate_img_url(id){
    return encodeURI(get_img_url().replace('#{id}', id));
  };

  function generate_item_img_src(){
    var query = recommendation_data.length ? recommendation_data[0][get_item_select()] : get_query();
    return encodeURI(get_img_url().replace('#{id}', query));
  };


  /*
  * Event Handlers
  */
  function fire_show_details(data){
    data = JSON.parse(data);
    data = $.mortar_data.util.get_largest_array(data)
    generate_col_selector_options('#item_select', data);
    generate_col_selector_options('#recommendation_select', data);
    generate_col_selector_options('#rank_select', data);
    recommendation_data = data;
    set_item_select(ITEM_KEY);
    set_recommendation_select(RECOMMENDATION_KEY);
    set_rank_select(RANK_KEY);
    generate_recommendation_list(data);
    //set_img_src('#item_img', generate_item_img_src());
    set_img_src();
    
  };

  function fire_detail_error(error_message){
  };

  function fire_select_change(data){
    ITEM_KEY = get_item_select();
    RECOMMENDATION_KEY = get_recommendation_select();
    RANK_KEY = get_rank_select();
    put_url_config();
    generate_recommendation_list(data) ;
    //set_img_src('#item_img', generate_item_img_src());
    set_img_src();
  };
 
  /*
   * Handler for clicking update button
   */ 
  function fire_update_url(){
    // = set_img_src('#item_img', generate_item_img_src()); 
    set_img_src();
    set_item_src();
    put_url_config();
  };


  function put_url_config(){
    $.mortar_data.api.put_url_config({
      image_url : get_img_url(),
      item_url : get_item_url(),
      item_key : get_item_select(),
      recommendation_key : get_recommendation_select(),
      rank_key : get_rank_select()
    });
  };

  function generate_col_selector_options(selector_id, recommendations){
    $(selector_id).empty();
    for (key in recommendations[0]){
      if (key.search('column') == 0)  {
        $(selector_id).append('<option>' + key + '</option>');
      }
    }
  };


  function generate_recommendation_list(recommendations){
    $('#recommendation_list').empty();
    for (var i=0; i < recommendations.length; i++){
      var item = recommendations[i]; 
      var span_size = 3;// relative to span12 on bootstrap
      var rec_id = item[get_recommendation_select()];
      var rank = item[get_rank_select()];
      $('#recommendation_list').append(
        '<li class="span' + span_size + '">' + 
          '<div class="well recommendation-well">' + 
            '<a class="thumbnail" href="'+ get_base_hash() + '/'+ rec_id + '">'+
                '<img onerror="this.src=\'images/default.png\'" class="img-polaroid recommendation_image" src="' + get_img_url().replace('#{id}', rec_id)+'" data="'+ rec_id + '"></img>'+
            '</a>' +
            '<h3 class="center text-crop" >Item Id: ' +rec_id + '</h3>' +
            '<h3 class="center">Rank: ' + rank + '</h3>' +
            '<a class="center" target="_blank"  href="' + get_item_url().replace('#{id}', rec_id) + '">To Item Page</a>'+
          '</div>'+
        '</li>'
      );
    };
  };

})();
