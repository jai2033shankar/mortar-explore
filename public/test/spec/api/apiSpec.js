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
});
