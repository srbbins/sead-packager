#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'fileutils'
require 'nokogiri'
require 'pathname'
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

ore = OreXml.new(f)



dc = DCXml.new

desired_fields = YAML.load_file('config/fields.yml')

puts dc.dc_root


desired_fields['fields'].each do |field|

  field[1].each do |qualifier|
    ore.document.xpath("//dcterms:#{field[0]}").each() do |node|
      node.children.each do |child_node|
        name = nil
        if child_node.is_foaf_name_node?
          name = node.xpath("foaf:name")[0].content
        elsif child_node.is_nonempty_text_node?
          name = child_node.content
        end
        if !name.nil?
          out_node = DCNode.new(dc.document, field[0], qualifier)
          out_node.content = name
          dc.dc_root << out_node.node
        end
      end
    end
  end
end



puts dc.document.to_s


