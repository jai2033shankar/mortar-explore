//  Copyright 2014 Mortar Data Inc.
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
// 
//      http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
(function(){
  /*  Controller Functions */
  function init_page(){
    window.onhashchange = function(e) {
      on_hash_change();
    };
    if (window.location.hash == ''){
      window.location.hash = '#browse';
    }
    on_hash_change();
  };


  /*  Event Handlers */
  function on_hash_change(){
    $('#explore_nav li').removeClass('active');
    $('.explore_content').addClass('hidden');
    var hash = window.location.hash;
    if (hash.search('/')>0){
      $('#detail_item').addClass('active');
      $('#detail_content').removeClass('hidden'); 
      $.mortar_data.details_view.init();
    }else{
      if(hash === '#browse' && !$.mortar_data.browse_view.is_rendered()){
        $.mortar_data.browse_view.init();
      }else if(hash === '#search'){
        $.mortar_data.search_view.init();
      }
      $(hash + '_item').addClass('active');  
      $(hash + '_content').removeClass('hidden');
    };
  };

  $(document).ready(function()  {
    init_page();
  });


})();
