class CrossWalk
  attr_accessor :ore, :dc


  def initialize(f)
    @dc = DCXml.new
    @ore = OreXml.new(f)
  end


  def transform
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
  end


end