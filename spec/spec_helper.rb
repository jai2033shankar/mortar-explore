#
# Copyright 2014 Mortar Data Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Portions of this code from heroku (https://github.com/heroku/heroku/) Copyright Heroku 2008 - 2012,
# used under an MIT license (https://github.com/heroku/heroku/blob/master/LICENSE).
#
 

require 'rspec'
require 'rr'
require "mortar/cli"

def get_all_item_item
  return [{:type=>"item_item", :weight=>"6.208612", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"3.5342972", :line=>"1", :item_A=>"big", :rank=>"1", :item_B=>"the wizard of oz"}, 
          {:type=>"item_item", :weight=>"6.0058064", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"3.970611", :line=>"2", :item_A=>"big", :rank=>"2", :item_B=>"peter pan"},
          {:type=>"item_item", :weight=>"5.896059", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"3.833774", :line=>"3", :item_A=>"big", :rank=>"3", :item_B=>"snow white"},
          {:type=>"item_item", :weight=>"5.5231767", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"4.8948455", :line=>"4", :item_A=>"big", :rank=>"4", :item_B=>"toy story"}, 
          {:type=>"item_item", :weight=>"4.407944", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"5.81908", :line=>"5", :item_A=>"big", :rank=>"5", :item_B=>"mary poppins"}, 
          {:type=>"item_item", :weight=>"3.9243095", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"8.266502", :line=>"6", :item_A=>"antz", :rank=>"1", :item_B=>"the lion king"},
          {:type=>"item_item", :weight=>"3.7120519", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"7.348985", :line=>"7", :item_A=>"antz", :rank=>"2", :item_B=>"honey i shrunk the kids"},
          {:type=>"item_item", :weight=>"3.2631755", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"1.3863515", :line=>"8", :item_A=>"antz", :rank=>"3", :item_B=>"a connecticut yankee in king arthur's court"},
          {:type=>"item_item", :weight=>"3.1456258", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"4.5953684", :line=>"9", :item_A=>"antz", :rank=>"4", :item_B=>"heaven can wait"},
          {:type=>"item_item", :weight=>"3.1211402", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"3.5740905", :line=>"10", :item_A=>"antz", :rank=>"5", :item_B=>"who killed roger rabbit?"},
          {:type=>"item_item", :weight=>"3.2222044", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"4.5953684", :line=>"11", :item_A=>"alien", :rank=>"1", :item_B=>"psycho"},
          {:type=>"item_item", :weight=>"2.986917", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"4.8948455", :line=>"12", :item_A=>"alien", :rank=>"2", :item_B=>"i know what you did last summer"},
          {:type=>"item_item", :weight=>"2.8968637", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"5.500517", :line=>"13", :item_A=>"alien", :rank=>"3", :item_B=>"nightmare on elm street"},
          {:type=>"item_item", :weight=>"2.873042", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"6.580674", :line=>"14", :item_A=>"alien", :rank=>"4", :item_B=>"tremors"},
          {:type=>"item_item", :weight=>"2.7485006", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"5.65644", :line=>"15", :item_A=>"alien", :rank=>"5", :item_B=>"scream"}
      ]
end

def execute(command_line, project=nil, git=nil)
  stderr, stdout, command = execute_and_return_command(command_line, project, git)  
  [stderr, stdout]
end

def execute_and_return_command(command_line, project= nil, git=nil)
  args = command_line.split(" ")
  command = args.shift

  Mortar::Command.load
  object, method = Mortar::Command.prepare_run(command, args)

  # stub the project
  if project
    any_instance_of(Mortar::Command::Base) do |base|
      stub(base).project.returns(project)
    end
  end

  # stub git
  if git
    # stub out any operations that affect remote resources
    stub(git).push
    
    any_instance_of(Mortar::Command::Base) do |base|
      stub(base).git.returns(git)
      stub(base).git_organization.returns("mortarcode-dev")
    end
  end

  original_stdin, original_stderr, original_stdout = $stdin, $stderr, $stdout

  $stdin  = captured_stdin  = StringIO.new
  $stderr = captured_stderr = StringIO.new
  $stdout = captured_stdout = StringIO.new

  begin
    object.send(method)
  rescue SystemExit
  ensure
    $stdin, $stderr, $stdout = original_stdin, original_stderr, original_stdout
    Mortar::Command.current_command = nil
  end

  [captured_stderr.string, captured_stdout.string, object]
end

def stub_core
  @stubbed_core ||= begin
    stubbed_core = nil
    stub(Mortar::Auth).user.returns("email@example.com")
    stub(Mortar::Auth).password.returns("pass")
    stubbed_core
  end
end


