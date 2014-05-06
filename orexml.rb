require 'fileutils'
require 'nokogiri'


class OreXml
  attr_reader :ore_not_well_formed, :document, :aggregation_id, :aggregated_resources

  def initialize(f)
    @document = Nokogiri::XML(f)
    @ore_well_formed = true
    find_aggregation_id
    find_aggregated_resources

  end

  def find_aggregation_id
    id_set=[]
    @document.xpath('//ore:isAggregatedBy').each {|node| id_set << node.content}
    id_set.uniq!
    if id_set.length != 1 then @ore_well_formed = false
    else @aggregation_id = id_set.first end
  end

  def find_aggregated_resources
    @aggregated_resources = []
    if @ore_well_formed
      @document.xpath('//ore:isAggregatedBy').each do |node|
        @aggregated_resources << node.parent.attribute("about").value
      end
    end

  end


end
