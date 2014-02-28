#
# Copyright 2012 Mortar Data Inc.
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


