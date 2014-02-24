require 'explore/mortar/local/search'


describe Search do
  base_direc = 'base/directory'
  before(:each) do
    search = Search.new(base_direc)
  end

  describe 'initialization' do
    
    it 'sets directory' do
      search = Search.new(base_direc)
      search.base_directory.should eq(base_direc)
    end
  end

  describe 'searching' do
    grep_query = 'grep hello base/directory -n'
    it 'finds all rows with searched string' do
      mock(Kernel).system(grep_query) {'hello'}    
      search.search('hello')
    end
  end

end
