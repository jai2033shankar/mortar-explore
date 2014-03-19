require "listen"

PLUGIN_NAME = File.basename(Dir.pwd).capitalize

def action(message)
  print "#{message}... "
  STDOUT.flush
  begin
    ret = yield
    puts "Success!"
  rescue Exception => e
    puts "FAILED!"
    puts
    puts e
    exit(0)
  end
end

folder_dependencies = %w(
  .bundle/
  bundle/
)

desc "Watch directory for changes, and auto install into mortar plugins directory"
task :watch => [:verify, :install] do
  print "Watching #{PLUGIN_NAME} for changes... "
  STDOUT.flush

  @listener = Listen.to(Dir.pwd,
                       :ignore => /\.(swp)/)
  changed = lambda do |modified, added, removed|
    puts "Success!"
    puts "File(s) changed:"
    for file in modified
      puts file 
    end
    Rake::Task["install"].execute
    Rake::Task["lessc"].execute
    Rake::Task["compile_js"].execute
    print "Watching #{PLUGIN_NAME} for changes... "
    STDOUT.flush
  end
  @listener.change(&changed)
  @listener.start!
end

desc "Check if dependencies are installed and sandboxed"
task :verify do
  action "Check dependencies are installed properly" do
    unless folder_dependencies.all? { |x| File.directory? x } 
      raise <<-ERROR
Gem dependencies haven't been bundled. Please run:

$ bundle install --standalone

ERROR
    
    end
  end
end


desc "Install plugin"
task :install do
  action "Installing plugin" do
    plugin_name = File.basename(Dir.pwd) + "/"
    system("mkdir -p ~/.mortar/plugins/#{plugin_name}; rsync -a -u --exclude='- *.' #{Dir.pwd}/ ~/.mortar/plugins/#{plugin_name}/")
  end
end

def compile_js (input_dir, output_dir, output_file)
  out = ""
  FileUtils.rm_rf(Dir.glob("#{output_dir}/*")) 
  Dir["#{input_dir}/*"].each do |directory|
    Dir[directory+"/*"].each do |file|
      out += File.read(file)
    end  
    base =  directory.split('/') 
  
  end
  File.open("#{output_dir}/#{output_file}", "a") { |file|
    file.write(out)
  }
end

desc "Compile javascript"
task :compile_js do
  action "Compiling javascript..." do
    compile_js("public/js", "public/bin", "main.js")  
    compile_js("public/test/spec", "public/test/bin", "mainSpec.js")  
  end
end

desc "Uninstall the #{PLUGIN_NAME} plugin"
task :clean do
  action "Removing #{PLUGIN_NAME} Plugin" do
    plugin_name = File.basename(Dir.pwd) + "/"
    system("rm -rf ~/.mortar/plugins/#{plugin_name}")
  end
end

desc "Compile CTags for #{PLUGIN_NAME} Plugin"
task :ctags do
  %x(ctags -R --exclude=bundle --exclude=js --exclude=css --exclude=flash --exclude=.git *)
  files = FileList["js/**/*.js"].select { |file|
    ! file.start_with?("js/lib")
  }
  puts "Generating ctags for files:"
  puts files
  system("jsctags #{files.join(" ")} -W debug")
  puts "Done generating ctags"
end

trap("INT") do
  @listener.stop if @listener
end



# compile less
require 'rubygems'
require 'less'
require 'rake'
 
SOURCE = "."
LESS = "public/css/less/"
CSS = "public/css/"
CONFIG = {
  'less'   => LESS,
  'css'    => CSS,
  'input'  => "main.less",
  'output' => "main.css"
}
 
desc "Compile Less"
task :lessc do
  less   = CONFIG['less']

  input  = File.join( less, CONFIG['input'] )
  output = File.join( CONFIG['css'], CONFIG['output'] )

  source = File.open( input, "r" ).read

  parser = Less::Parser.new( :paths => [less] )
  tree = parser.parse( source )
  puts "Rebuilding Less files"

  File.open( output, "w+" ) do |f|
    f.puts tree.to_css( :compress => true )
  end
end 
