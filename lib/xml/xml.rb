require 'nokogiri'

class CodeBlocks::XmlParser
	def self.getXML(fileName)
		xml_file = File.open fileName
		xml_node = Nokogiri::XML(xml_file)
		xml_file.close
		return xml_node
	end
end
