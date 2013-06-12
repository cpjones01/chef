#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Daniel DeLeo (<dan@opscode.com>)
# Copyright:: Copyright (c) 2008, 2010 Opscode, Inc.
# License:: Apache License, Version 2.0
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

require File.dirname(__FILE__) + '/lib/chef/version'

require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'
require './tasks/rspec.rb'

GEM_NAME = "chef"

spec = eval(File.read("chef.gemspec"))

# This has to be here or else the docs get generated *after* the gem is created
task :gem => 'docs:all'

Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

begin
  require 'sdoc'

  Rake::RDocTask.new do |rdoc|
    rdoc.title = "Chef Ruby API Documentation"
    rdoc.main = "README.rdoc"
    rdoc.options << '--fmt' << 'shtml' # explictly set shtml generator
    rdoc.template = 'direct' # lighter template
    rdoc.rdoc_files.include("README.rdoc", "LICENSE", "spec/tiny_server.rb", "lib/**/*.rb")
    rdoc.rdoc_dir = "rdoc"
  end
rescue LoadError
  puts "sdoc is not available. (sudo) gem install sdoc to generate rdoc documentation."
rescue TypeError
  puts "sdoc is not working on ruby-2.0.0 and throwing an odd TypeError, rdoc generation will be disabled on ruby 2.0 until that gets fixed."
end

task :install => :package do
  sh %{gem install pkg/#{GEM_NAME}-#{Chef::VERSION}.gem --no-rdoc --no-ri}
end

task :uninstall do
  sh %{gem uninstall #{GEM_NAME} -x -v #{Chef::VERSION} }
end

RONN_OPTS = "--manual='Chef Manual' --organization='Chef #{Chef::VERSION}' --date='#{Time.new.strftime('%Y-%m-%d')}'"

namespace :docs do
  desc "Regenerate manpages from markdown"
  task :man

  desc "Regenerate HTML manual from markdown"
  task :html

  desc "Regenerate help topics from man pages"
  task :list => :man do
    topics = Array.new

    Dir['distro/common/man/man1/*.1'].each do |man|
      topics << File.basename(man, '.1')
    end

    File.open('lib/chef/knife/help_topics.rb', 'w') do |f|
      f.puts "# Do not edit this file by hand"
      f.puts "# This file is autogenerated by the docs:list rake task from the available manpages\n\n"

      f.puts "HELP_TOPICS = #{topics.inspect}"
    end
  end

  if system('which ronn > /dev/null')
    ['distro/common/markdown/man1/*.mkd', 'distro/common/markdown/man8/*.mkd'].each do |dir|
      Dir[dir].each do |mkd|
        basename = File.basename(mkd, '.mkd')
        if dir =~ /man1/
          manfile = "distro/common/man/man1/#{basename}.1"
          htmlfile = "distro/common/html/#{basename}.1.html"
        elsif dir =~ /man8/
          manfile = "distro/common/man/man8/#{basename}.8"
          htmlfile = "distro/common/html/#{basename}.8.html"
        end

        file(manfile => [mkd, 'lib/chef/version.rb']) do
           sh "ronn -r #{RONN_OPTS} #{mkd} --pipe > #{manfile}"
         end
         task :man => manfile

         file(htmlfile => [mkd, 'lib/chef/version.rb']) do
           sh "ronn -5 #{RONN_OPTS} --style=toc #{mkd} --pipe > #{htmlfile}"
         end
         task :html => htmlfile

      end
    end
  else
    puts "get with the program and install ronn"
  end

  task :all => [:man, :html]
end

task :docs => "docs:all"



