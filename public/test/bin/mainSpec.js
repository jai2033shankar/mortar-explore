describe("Api", function() {
  var api = $.mortar_data.api;
  beforeEach(function() {
    spyOn($, 'ajax');
  });

  describe("get_browse", function() {
    var quantity = 10,
      index = 1,
      directory = 'my/direc';

    var params = {
      quantity  : quantity,  
      index     : index,
      directory : directory
    };

    it("should set the params correctly", function() {
      api.get_browse(quantity, index, directory, 'foo', 'bar'); 
      expect($.ajax).toHaveBeenCalledWith({
        url: '/api/v1/browse',
        data: params,
        success: 'foo',
        error: 'bar'
      });
    });
  });

  describe("get_search", function() {
    var query = 'my_query';

    it("should set the params correctly", function() {
      api.get_search(query, 'foo', 'bar'); 
      expect($.ajax).toHaveBeenCalledWith({
        url: '/api/v1/search',
        data: {query:query},
        success: 'foo',
        error: 'bar'
      });
    });
  });

  describe("get_recommend", function() {
    var query = 'my_query',
        directory = 'dir';

    it("should set the params correctly", function() {
      api.get_recommend(query, directory,'foo', 'bar'); 
      expect($.ajax).toHaveBeenCalledWith({
        url: '/api/v1/recommend',
        data: {query:query, directory:directory},
        success: 'foo',
        error: 'bar'
      });
    });
  });
});
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
describe('Details page', function(){
  beforeEach(function() {
    spyOn($.ajax);  
  }); 
  it('should make a call for get_recommend', function() {
    expect($.ajax).toHaveBeenCalledWith({
      url: '/api/v1/recommend',
      data: {query:'query', directory:'directory'},
      success: 'foo',
      error: 'bar'
    }); 
  });
});
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
describe("Explore", function() {
  
  describe("on initialize page", function() {
    it('should set hash to browse', function() {
      expect(window.location.hash).toBe('#browse');
    });

    it('should hide explore content', function() {
//      expect($('.explore_content')).toBe(true);   
    }); 
  });

});
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
describe("Mortar Widget Table", function(){
  var generate_items = function(size){
    res = [];
    for(var i = 0; i < size; i++){
       res.push({
         item_A: i,
         item_B: i +1,
         user: i-1
       }); 
    }
    return res;
  };
  var widget = null;
  beforeEach(function() {
    widget = new MortarTable(
                  '#div_id',
                  generate_items(10),
                  {} 
                 );
  });

  describe('Initialization', function(){
    it('should set the index to 0', function() {
      expect(widget.index).toBe(0);
    });

    it('should set the key_array', function() {
      expect(widget.key_array[0]).toBe('item_A');
      expect(widget.key_array[1]).toBe('item_B');
      expect(widget.key_array[2]).toBe('user');
      expect(widget.key_array.length).toBe(3);
    });
  });
  xdescribe('draw', function(){
  });
    
  describe('details button', function(){
    beforeEach(function() {
      widget = new MortarTable(
                      '#div_id',
                      generate_items(10), 
                      {} 
                    );
    });

  });
});

