require 'csv'
require 'nokogiri'
require 'open-uri'

# iterate over the files listed on the command line
#
#if (ARGV.length == 0)
#  puts "specify at least one input file on the command line"
#  exit 1
#end

#noheaders = (ARGV.length > 0 && ARGV[0] == '--noheaders')

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

## write out the headers
#if (!noheaders)
#  csv << rel_keys
#end

csv << csv_keys

# read standard input.  expect one filename per line of input.
$stdin.each do | line |
  file = line.chomp()
  
  doc = File.open(file) { |f| Nokogiri::XML(f) }

  results = doc.xpath("//Organization")
  #orgs = results
  
#  puts "results ->"   
#  puts results.class.to_s + " " + results.length.to_s + " - " + results.to_s
#  exit

  # iterate over the results
  results.each do | each |
    #puts each.class.to_s + " " + each.to_s
    #exit
    
    # put all the values in a hash for easy access
    hash = Hash.new('')
    each.elements.each do |e|
      hash[e.name] = e.content()
    end

    row = csv_keys.collect { | k | hash[k] }

    # write out the row of data to the CSV
    csv << row

  end

end