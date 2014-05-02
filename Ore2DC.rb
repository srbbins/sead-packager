#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'fileutils'
require 'nokogiri'
require 'pathname'
require_relative 'cross_walk'
require_relative 'dc_node'
require_relative 'orexml'
require_relative 'dcxml'

module Nokogiri
  module XML
    class Node
      def is_nonempty_text_node?
        return self.class.name == "Nokogiri::XML::Text" && self.content.strip != ""
      end
      def is_foaf_name_node?
        return !self.namespace.nil? && self.namespace.prefix == "foaf" && self.name == "name"
      end
    end
  end
end

f = File.new ARGV[0]
if ARGV.length == 2
  out = ARGV[1]
else 
  out = "dc.xml"
end

crosswalk = CrossWalk.new(f)
crosswalk.transform


puts crosswalk.dc.document.to_s


