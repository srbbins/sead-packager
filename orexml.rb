require 'fileutils'
require 'nokogiri'


class OreXml
  attr_reader :ore_not_well_formed, :document, :aggregation_id, :aggregated_resources

  def initialize(f)
    @ore_not_well_formed = false
    @document = Nokogiri::XML(f)
    find_aggregation_id

  end
  #ends-with(@rdf:about, "_Aggregation")
  def find_aggregation_id
    id_set=[]
    @document.xpath('//ore:isAggregatedBy').each {|node| id_set << node.content}
    id_set.uniq!
    puts "in orexml"
    puts id_set.inspect
    if id_set.length != 1 then ore_not_well_formed = true
    else @aggregation_id = id_set.first end


  end

end
