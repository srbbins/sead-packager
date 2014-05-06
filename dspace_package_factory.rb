require 'd_space_cross_walk'
class DspacePackageFactory
  def initialize(ore)
    @ore = ore
  end
  # needs to get filenames from each agregated id and generate metadata
  def generate
    package_array = []
    @ore.aggregated_resources.each do |id|
      crosswalk = DSpaceCrossWalk.new(@ore, id)
      metadata = crosswalk.dc
      filenames = get_filenames(id)
      package_array << DSpacePackage.new(filenames, metadata)
    end
    return package_array
  end

  def get_filenames(id)
    filenames = []
    @ore.document.xpath("//rdf:Description[@rdf:about='"+id+"']/mets:FLocat").each do |node|

     filenames << node.content
    end
    return filenames
  end
end