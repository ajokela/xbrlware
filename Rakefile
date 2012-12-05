#!/usr/bin/ruby
#
# Author:: xbrlware@bitstat.com
#
# Copyright:: 2009, 2010 bitstat (http://www.bitstat.com). All Rights Reserved.
#
# License:: Licensed under the Apache License, Version 2.0 (the "License");
#           you may not use this file except in compliance with the License.
#           You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#           Unless required by applicable law or agreed to in writing, software
#           distributed under the License is distributed on an "AS IS" BASIS,
#           WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#           implied.
#           See the License for the specific language governing permissions and
#           limitations under the License.
#
require 'rubygems'
gem 'rake'

require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'xbrlware/version'


LIBDIR = 'lib'
DOCDIR = 'doc'
TESTDIR = 'test'
EXAMPLEDIR = 'example'

# Configure some constants and built-in tasks
PKG_VERSION = Xbrlware::VERSION

COMMUNITY_EDITION = 'xbrlware-ce'
PKG_NAME = ENV['EDT'] ? ENV['EDT'] : COMMUNITY_EDITION

PKG_DEPENDENCY={}
PKG_DEPENDENCY = {'xml-simple' => '= 1.0.12'} if PKG_DEPENDENCY.nil?
PKG_DEPENDENCY['xml-simple'] = '= 1.0.12' unless PKG_DEPENDENCY.nil?  

SCHEMA_VALIDATION="True"
unless ENV.include?("SCHEMA_VALIDATION")
  ENV["SCHEMA_VALIDATION"]=SCHEMA_VALIDATION
end

task :default => "test"


# ========================================================================
# Create a task to perform the unit testing.
Rake::TestTask.new(:test) do |t|
  t.test_files = FileList[
          'test/lib/**/*_test.rb'
  ]
  t.warning = false
  t.verbose = false
end

# ========================================================================
# Create a task to build the RDOC documentation tree.
Rake::RDocTask.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = DOCDIR
  rdoc.title = 'xbrlware -- A fast, lightweight framework for automation & analysis of XBRL.'
  rdoc.main = 'Readme.txt'
  rdoc.rdoc_files.include('Readme.txt')
  rdoc.rdoc_files.include("#{LIBDIR}/**/*.rb")
  rdoc.rdoc_files.exclude("#{LIBDIR}/xbrlware/taxonomies/*.rb")
  rdoc.rdoc_files.exclude("#{LIBDIR}/code_gen/*")
  rdoc.rdoc_files.exclude("RakefileEE.rb")
  rdoc.rdoc_files.exclude("Rakefile.rb")
end

# ========================================================================
# Create a task that will package the Rake software into distributable
# gem files.
PKG_FILES = FileList[
        '*.*',
                "#{LIBDIR}/**/*.rb",
                "#{DOCDIR}/**/*.*",
                "#{TESTDIR}/**/*.*",
                "#{EXAMPLEDIR}/**/*.*"
]

PKG_FILES.exclude("#{LIBDIR}/code_gen/*")
PKG_FILES.exclude("RakefileEE.rb")
PKG_FILES.exclude("Rakefile")
PKG_FILES.exclude(/\._/)

def gem_spec
  Gem::Specification.new do |s|

    # Basic information
    s.name = PKG_NAME
    s.version = PKG_VERSION
    s.summary = 'A fast, lightweight framework for automation & analysis of XBRL.'
    description = "A fast, lightweight framework to parse, extract information from XBRL Instance, Taxonomy and Linkbase documents." +
            "\nxbrlware understands structure and relationship among elements of XBRL documents and" +
            "\ndefines a set of APIs for accessing financial & business facts, meta & other related information"+
            "\ndefined in XBRL documents."

    s.description = description

    # Files and dependencies
    s.files = PKG_FILES.to_a
    s.require_path = LIBDIR
    PKG_DEPENDENCY.each do |name, ver|
      s.add_dependency(name, ver)
    end

    # RDoc information
    s.has_rdoc = true
    s.extra_rdoc_files = ['Readme.txt']
    s.rdoc_options << '--main' << 'Readme.txt'

    # Metadata
    s.authors = ['bitstat technologies']
    s.email = 'xbrlware@bitstat.com'
    s.homepage = 'http://www.bitstat.com/xbrlware/'
    s.rubyforge_project = 'xbrlware'
    s.requirements << 'xml-simple v1.0.12'
  end
end

unless defined?(Gem)
  puts "Package Target requires RubyGems"
else
  Rake::GemPackageTask.new(gem_spec) do |t|
    t.need_tar = true
  end
end
