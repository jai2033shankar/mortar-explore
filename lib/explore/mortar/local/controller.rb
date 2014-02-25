#
# Copyright 2013 Mortar Data Inc.
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
require "explore/mortar/local/explorer"
require 'explore/mortar/local/search'
require "mortar/local/controller"

class Mortar::Local::Controller
  def explore(project, data_directory, port)
    port ||= 3000 
    explorer = Mortar::Local::Explorer.new(project.root_path)

    # Startup Web server
    Server.set :data_directory, data_directory 
    Server.set :project_root, project.root_path
    Server.set :searcher, Search.new(data_directory)
    begin
      server = Thin::Server.new(Server, '0.0.0.0', port, :signals => false)
    rescue => e
      print 'error'
    end

    server.start
    launch_browser(port)

  end

  private

  # Private: launch the web browser once we've heard back and
  # verified the pigjig server has started
  #
  # Returns nothing
  def launch_browser(port) 
    begin
      require "launchy"
      Launchy.open("http://localhost:#{port}")
    rescue => msg
      warning "Unable to automatically launch browser. Please visit http://localhost:#{port}"
    end
  end

  def styled_error(error, message='Watchtower internal error.')
    $stderr.puts(" !    #{message}.")
    $stderr.puts(" !    Report a bug at: https://github.com/mortardata/watchtower/issues/new")
    $stderr.puts
    $stderr.puts("    Error:       #{error.message} (#{error.class})")
    $stderr.puts("    Backtrace:   #{error.backtrace.first}")
    error.backtrace[1..-1].each do |line|
      $stderr.puts("                 #{line}")
    end
    if error.backtrace.length > 1
      $stderr.puts
    end
    command = ARGV.map do |arg|
      if arg.include?(' ')
        arg = %{"#{arg}"}
      else
        arg
      end
    end.join(' ')
    $stderr.puts
  end


end
