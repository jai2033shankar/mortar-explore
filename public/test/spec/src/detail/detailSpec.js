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
