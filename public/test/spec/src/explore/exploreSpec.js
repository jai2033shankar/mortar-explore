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
