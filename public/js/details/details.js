$.mortar_data = $.mortar_data || {};
$.mortar_data.details_view = $.mortar_data.details_view || {};



(function () {
  $.mortar_data.details_view.init = function(){
    init_details();
    
  }; 
  function init_details(){
    get_recommend(); 
    set_img_url('http://images.amazon.com/images/P/#{id}.01.MZZZZZZZ.jpg');
    set_img_src();
    set_breadcrumbs();
    $('#update_url').click(set_img_src);

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
    $('#detail_base').append('<a href="' + get_base_hash() + '">' + base + '</a>'); 
    $('#detail_id').text(get_query());
  };

  /*
   * sets image url text box
   */
  function set_img_url(url){
    $('#image_url').val(url);
  };

  function get_img_url(){
    return $('#image_url').val();
  };

  function generate_item_img_src(){
    return get_img_url().replace('#{id}', get_query());
  };

  function set_img_src(){
    $('#item_img').attr('src', generate_item_img_src());
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

  function generate_recommendation_list(recommendations){
    $('#recommendation_list').empty();
    for(var i=0; i < recommendations.length; i++){
      var item = recommendations[i]; 
      var span_size = 4;// relative to span12 on bootstrap
      $('#recommendation_list').append(
        '<li class="span' + span_size + '">' + 
          '<a class="thumbnail" href="'+ get_base_hash() + '/'+ item.item_B + '">'+
            '<img class="img-polaroid" src="' + get_img_url().replace('#{id}', item.item_B)+'"></img>'+
          '</a>' +
        '</li>'
      );

    };
  };

})();
