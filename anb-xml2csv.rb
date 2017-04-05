require 'csv'
require 'nokogiri'
require 'open-uri'

csv = CSV($stdout, force_quotes: false)

csv_keys = [ 
  'UnitType',        
  'Affiliation',  
  'Allegiance',   
  'CurrentStrength',
  'UnitFunctionalRole',
  'NumberofPersonnel',
  'NumberofNCOs', 
  'NumberofOfficers',
  'NumberofEnlisted',
  'IntelligenceEvaluation',
  'UnitTitle',    
  'UnitNumber',   
  'UnitEchelon',  
  'RawUnitName',  
  'InternalUse',  
  'SymbolCode',   
  'Latitude',     
  'Longitude',    
  'PrimaryImage', 
  'EntityType'
]

csv << csv_keys

# read standard input.  expect one filename per line of input.
$stdin.each do | line |
  file = line.chomp()
  
  doc = File.open(file) { |f| Nokogiri::XML(f) }
  results = doc.xpath("//Organization")

  # iterate over the results
  results.each do | each |    
    # put all the values in a hash for easy access
    hash = Hash.new('')
    each.elements.each do |e|
      hash[e.name] = e.content()
    end
    
    # remove extra stuff that precedes colon
    hash.each do | k, v|
      parsed = /^(?<tag>[^:]+):\s*(?<value>.*)/.match(v)
      if (parsed && parsed[:tag])  #
        #puts parsed[:tag]
        #puts parsed[:value]
        
        # update the value to include everything after the colon
        hash[k] = parsed[:value]  
      end 
              
    end

    row = csv_keys.collect { | k | hash[k] }

    # write out the row of data to the CSV
    csv << row

  end

end