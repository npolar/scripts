#!/usr/bin/env ruby
# Fetch MMS Excel files from disk, create metadata to store in the ecotox-excel database.
# Create an UUID for each file and move file to server disk. Send the link between file and uuid
# to a file "log". Use file to get the uuids for filenames when you read from the
# old Oracle database.
#
# Author: srldl
#
########################################

require './config'
require './server'
require 'net/http'
require 'net/ssh'
require 'net/scp'
require 'time'
require 'date'
require 'json'
require 'rmagick'



module Couch

  class EcotoxExcel

    #Get hold of UUID for database storage
    def self.getUUID(server)

       #Fetch a UUID from couchdb
       res = server.get("/_uuids")


       #Extract the UUID from reply
       uuid = (res.body).split('"')[3]

       #Convert UUID to RFC UUID
       uuid.insert 8, "-"
       uuid.insert 13, "-"
       uuid.insert 18, "-"
       uuid.insert 23, "-"
       return uuid
    end

       #Set server
       host3 = Couch::Config::HOST3
       port3 = Couch::Config::PORT3
       user3 = Couch::Config::USER3
       password3 = Couch::Config::PASSWORD3

       #Set server
       host = Couch::Config::HOST2
       port = Couch::Config::PORT2
       user = Couch::Config::USER2
       password = Couch::Config::PASSWORD2


       # do work on files ending in .xls in the desired directory
    Dir.glob('./files_toprod/*.xls*') do |excel_file|

       #Get filename -last part of array (path is the first)
       filename =  excel_file[15..-1]
       filename.gsub!(' ','_')
       puts filename


       #get UUID
       #Get ready to put into database
       server = Couch::Server.new(host, port)
       server3 = Couch::Server.new(host3,port3)

       #Fetch a UUID from courchdb
       res = server.get("/_uuids")


       #Extract the UUID from reply
       uuid = (res.body).split('"')[3]


       #Convert UUID to RFC UUID
       uuid.insert 8, "-"
       uuid.insert 13, "-"
       uuid.insert 18, "-"
       uuid.insert 23, "-"

       #Timestamp
       a = (Time.now).to_s
       b = a.split(" ")
       c = b[0].split("-")
       dt = DateTime.new(c[0].to_i, c[1].to_i, c[2].to_i, 12, 0, 0, 0)
       timestamp = dt.to_time.utc.iso8601

       #Extract the MD5 checksum from reply
       md5excel = Digest::MD5.hexdigest(filename)

       #Create shema
       @entry = {
            :id => uuid,
            :_id => uuid,
            :schema => 'http://api.npolar.no/schema/ecotox-excel',
            :collection => 'ecotox-excel',
            :base => 'http://api.npolar.no',
            :lang => 'en',  #converted to eng for the database
            :rights => 'No licence announced on web site',
            :uri =>  "https://api.npolar.no/ecotox-excel/" + uuid + "/_file/" + filename,
            :filename => filename,
            :type => "application/vnd.ms-excel", #last digits
            :length => (File.size(excel_file)).to_i, #size
            :hash => md5excel,
            :created => timestamp,
            :updated => timestamp,
            :created_by => user,
            :updated_by => user
      }

    #Traverse @entry and remove all empty entries
    @entry.each do | key, val |
        if  val == "" || val == "" || val == nil
              #  puts key
                @entry.delete(key)
        end
    end

    #Convert to json
    doc = @entry.to_json

    #post the attchment to server
    #Not good slurping the file, but the file sizes are small
    excel = File.read(excel_file)

    #app is the content-type
    app = 'application/vnd.ms-excel'
    if (excel_file.include? "xlsx")
        app = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    end

    puts "app" + app


    @uri2 = URI.parse('http://api-test.data.npolar.no/ecotox-excel/' + uuid + '/_file/restricted/'+ filename)
    http2 = Net::HTTP.new(@uri2.host, @uri2.port)
    req = Net::HTTP::Post.new(@uri2.path,{'Authorization' => Couch::Config::AUTH3, 'Content-Type' => app})
    req.body = excel
    req.basic_auth(user3, password3)
    res = http2.request(req)
    body = res.body
    puts body.to_json


    #Post to server
    @uri = URI.parse('http://api-test.data.npolar.no/ecotox-excel')
    http = Net::HTTP.new(@uri.host, @uri.port)
    req = Net::HTTP::Post.new(@uri.path,{'Authorization' => Couch::Config::AUTH3, 'Content-Type' => 'application/json' })
    req.body = doc
    req.basic_auth(user3, password3)
    res = http.request(req)
    puts (res.header).inspect
    puts (res.body).inspect


    #Finally write the uuid and the filename to the file excel_uuid
    text = uuid.to_s + ' : ' + (File.size(excel_file)).to_s + ' : ' + filename + ' : ' + app + ' | '
    inputfile = 'log'
    File.open(inputfile, 'a') { |f| f.write(text) }

end


end #class
end #module
