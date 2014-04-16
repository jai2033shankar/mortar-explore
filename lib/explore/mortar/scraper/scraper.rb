
class Scraper
  attr_accessor :base_directory, :delim_char, :index

  def initialize(base_directory, delim_char = "\t")
    @base_directory = base_directory
    @delim_char = delim_char 
    @index = 1
  end


end
