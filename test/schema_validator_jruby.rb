java_import javax.xml.XMLConstants
java_import javax.xml.parsers.DocumentBuilder
java_import javax.xml.parsers.DocumentBuilderFactory
java_import javax.xml.transform.Source
java_import javax.xml.transform.dom.DOMSource
java_import javax.xml.transform.stream.StreamSource
java_import javax.xml.validation.Schema
java_import javax.xml.validation.SchemaFactory
java_import javax.xml.validation.Validator

java_import org.w3c.dom.Document
java_import org.xml.sax.SAXException

module XbrlTest
  class SchemaValidator
    
    def self.validate (xml_file, xsd_file)

      unless ENV["SCHEMA_VALIDATION"].nil?        
        return if ENV["SCHEMA_VALIDATION"]=="False" || ENV["SCHEMA_VALIDATION"]=="false"
      end
      
      docBuilder = DocumentBuilderFactory.newInstance()
      docBuilder.setNamespaceAware(true)
      docBuilder.setXIncludeAware(true)
      
      parser = docBuilder.newDocumentBuilder()
      document = parser.parse(java.io.File.new(xml_file))
      factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema")
      
      schemaFile = StreamSource.new(java.io.File.new(xsd_file))
      schema = factory.newSchema(schemaFile)
      
      validator = schema.newValidator()
      validator.validate(DOMSource.new(document))    

    end
    
  end
end