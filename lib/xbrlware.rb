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
gem 'xml-simple', '= 1.0.12'
require 'xmlsimple'

require 'date'
require 'bigdecimal'
require 'erb'
require 'set'
require "stringio"
require 'cgi'

require 'xbrlware/version'
require 'xbrlware/float_patch'
require 'xbrlware/cgi_patch'
require 'xbrlware/meta_util'
require 'xbrlware/hash_util'
require 'xbrlware/date_util'
require 'xbrlware/xml_parser'

require 'xbrlware/constants'
require 'xbrlware/util'

require 'xbrlware/taxonomies/us_gaap_taxonomy_20090131'

module Xbrlware; module Taxonomies
autoload :IFRS20090401, 'xbrlware/taxonomies/ifrs_taxonomy_20090401'
end; end;

require 'xbrlware/taxonomy'

require 'xbrlware/ns_aware'
require 'xbrlware/context'
require 'xbrlware/instance'
require 'xbrlware/unit'
require 'xbrlware/item'

require 'xbrlware/linkbase/linkbase'
require 'xbrlware/linkbase/label_linkbase'
require 'xbrlware/linkbase/calculation_linkbase'
require 'xbrlware/linkbase/definition_linkbase'
require 'xbrlware/linkbase/presentation_linkbase'

require 'logger'
require 'benchmark'

ENV["TAXO_NAME"]="US-GAAP"
ENV["TAXO_VER"]="20090131"

$LOG = Logger.new($stdout)
$LOG.level = Logger::INFO

def bm(title, measure) # :nodoc:
  $LOG.debug title +" [ u :"+measure.utime.to_s+", s :"+measure.stime.to_s+", t :"+measure.total.to_s+", r :"+measure.real.to_s+"]"    
end