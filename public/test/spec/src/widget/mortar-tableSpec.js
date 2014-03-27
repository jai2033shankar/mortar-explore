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

