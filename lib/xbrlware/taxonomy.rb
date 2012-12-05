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
module Xbrlware

  # Class to deal with taxonomy of instance file.
  class Taxonomy

    attr_accessor :ignore_lablb, :ignore_deflb, :ignore_prelb, :ignore_callb
    attr_reader :taxonomy_content

    # Creates a Taxonomy.
    #
    # taxonomy_path:: Instance taxonomy source path.
    # instance:: Instance object  
    def initialize(taxonomy_path, instance)
      @instance=instance
      @taxonomy_content=nil

      @taxonomy_file_basedir=nil
      unless taxonomy_path.nil?
        m=Benchmark.measure do
          begin
            @taxonomy_content=XmlParser.xml_in(taxonomy_path, {'ForceContent' => true})
          rescue Exception
            @taxonomy_content=XmlParser.xml_in(File.open(taxonomy_path).read.gsub("\n", ""), {'ForceContent' => true})
          end
          @taxonomy_file_basedir=File.dirname(taxonomy_path)+File::Separator
        end
        bm("Parsing [" + taxonomy_path + "] took", m)
      end

      @taxonomy_def_instance=TaxonomyDefintion.new
      @taxonomy_content["element"].each do |element|
        MetaUtil::introduce_instance_var(@taxonomy_def_instance, element["name"].gsub(/[^a-zA-Z0-9_]/, "_"), element)
      end unless @taxonomy_content.nil? || @taxonomy_content["element"].nil?

      @lablb=@deflb=@prelb=@callb=nil
      @ignore_lablb=@ignore_deflb=@ignore_prelb=@ignore_callb=false
    end

    # gets taxonomy definition 
    def definition(name)
      @taxonomy_def_instance.send(name.gsub(/[^a-zA-Z0-9_]/, "_"))
    end

    # initialize and returns label linkbase 
    def lablb(file_path=nil)
      return nil if @ignore_lablb
      file_path=linkbase_href(Xbrlware::LBConstants::LABEL) if file_path.nil? && @lablb.nil?
      $LOG.debug("Label linkbase path #{file_path}")
      return @lablb if file_path.nil?
      if File.exist?(file_path)
        @lablb = Xbrlware::Linkbase::LabelLinkbase.new(file_path)
      else
        $LOG.warn(" Label linkbase file not exist " + file_path)
        @lablb = nil
      end
      @lablb
    end

    # initialize and returns definition linkbase
    def deflb(file_path=nil)
      return nil if @ignore_deflb
      file_path=linkbase_href(Xbrlware::LBConstants::DEFINITION) if file_path.nil? && @deflb.nil?
      $LOG.debug("Definition linkbase path #{file_path}")
      return @deflb if file_path.nil?

      if File.exist?(file_path)
        @deflb = Xbrlware::Linkbase::DefinitionLinkbase.new(file_path, lablb())
      else
        $LOG.warn(" Definition linkbase file not exist " + file_path)
        @deflb = nil
      end
      @deflb
    end

    # initialize and returns presentation linkbase
    def prelb(file_path=nil, definitions=lb_definitions())
      return nil if @ignore_prelb
      file_path=linkbase_href(Xbrlware::LBConstants::PRESENTATION) if file_path.nil? && @prelb.nil?
      $LOG.debug("Presentation linkbase path #{file_path}")
      return @prelb if file_path.nil?

      if File.exist?(file_path)
        @prelb = Xbrlware::Linkbase::PresentationLinkbase.new(file_path, @instance, definitions, lablb)
      else
        $LOG.warn(" Presentation linkbase file not exist " + file_path)
        @prelb = nil
      end
      @prelb
    end

    # initialize and returns calculation linkbase
    def callb(file_path=nil)
      return nil if @ignore_callb
      file_path=linkbase_href(Xbrlware::LBConstants::CALCULATION) if file_path.nil? && @callb.nil?
      $LOG.debug("Calculation linkbase path #{file_path}")
      return @callb if file_path.nil?
      if File.exist?(file_path)
        @callb = Xbrlware::Linkbase::CalculationLinkbase.new(file_path, @instance, lablb)
      else
        $LOG.warn(" Calculation linkbase file not exist " + file_path)
        @callb = nil
      end
      @callb
    end

    # initialize all linkbases
    def init_all_lb(cal_file_path=nil, pre_file_path=nil, lab_file_path=nil, def_file_path=nil)
      @lablb=@deflb=@prelb=@callb=nil
      lablb(lab_file_path)
      deflb(def_file_path)
      prelb(pre_file_path, @deflb.definition) unless @deflb.nil? 
      prelb(pre_file_path, []) if @deflb.nil?
      callb(cal_file_path)
      return
    end

    # Linkebase file paths
    #
    # linkbase_constant:: Xbrlware::LBConstants ::CALCULATION
    #                     Xbrlware::LBConstants ::DEFINITION
    #                     Xbrlware::LBConstants ::PRESENTATION
    #                     Xbrlware::LBConstants ::LABEL
    #                     Xbrlware::LBConstants ::REFERENCE
    def lb_paths(linkbase_constant)
      paths=[]
      begin
        linkbase_refs=@taxonomy_content["annotation"][0]["appinfo"][0]["linkbaseRef"]
        linkbase_refs.each do |ref|
          if ref["xlink:role"]==linkbase_constant
            paths << "#{@taxonomy_file_basedir}#{ref["xml:base"]}#{ref["xlink:href"]}"
          end
        end
      rescue Exception => e
      end
      paths
    end

    # initialize and returns all calculations
    def calculations
      cals=[]
      cal_paths=lb_paths(Xbrlware::LBConstants::CALCULATION)
      cal_paths.each do |path|
        _callb = callb(path)
        cals += _callb.calculation unless _callb.nil?
      end
      cals
    end

    # initialize and returns all linkbase definitions
    def lb_definitions
      des=[]
      def_paths=lb_paths(Xbrlware::LBConstants::DEFINITION)
      def_paths.each do |path|
        _deflb = deflb(path)
        des += _deflb.definition unless _deflb.nil?
      end
      des
    end

    # initialize and returns all presentations
    def presentations
      pres=[]
      defs=lb_definitions
      pre_paths=lb_paths(Xbrlware::LBConstants::PRESENTATION)
      pre_paths.each do |path|
        _prelb = prelb(path, defs)
        pres += _prelb.presentation unless _prelb.nil?
      end
      pres
    end

    private
    def linkbase_href(linkbase)
      begin
        linkbase_refs=@taxonomy_content["annotation"][0]["appinfo"][0]["linkbaseRef"]
        linkbase_refs.each do |ref|
          if ref["xlink:role"]==linkbase
            return @taxonomy_file_basedir + ref["xlink:href"] if ref["xml:base"].nil?
            return @taxonomy_file_basedir + ref["xml:base"] + ref["xlink:href"]
          end
        end
      rescue Exception => e
      end
      nil
    end
  end

  class TaxonomyDefintion

    def initialize
      taxonomy_module=ENV["TAXO_NAME"].to_s.sub("-", "") + ENV["TAXO_VER"].to_s
      if eval("defined?(Taxonomies::#{taxonomy_module}) == 'constant' and Taxonomies::#{taxonomy_module}.class == Module")
        eval("self.extend Taxonomies::#{taxonomy_module}")
      else
        $LOG.warn("No taxonomy found for name ["+ENV["TAXO_NAME"].to_s+"] and version ["+ENV["TAXO_VER"].to_s+"]")
      end
    end

    def method_missing(m, *args)
      nil
    end
  end
end