#!/usr/bin/env ruby
# Convert inteval field from string to int
# update the radiation-weather database
# pole KNG6.
#
#
# Author: srldl
#
# Requirements: Excel input file with new entries
#
########################################

require '../../config'
require '../../server'
require 'net/http'
require 'time'
require 'date'
require 'json'
require 'digest'
require 'spreadsheet'
require 'securerandom'
require 'fileutils'

module Couch

  class ReadFromDatabase

    #Set server end destination
    host = Couch::Config::HOST3
    port = Couch::Config::PORT3
    user = Couch::Config::USER3
    password = Couch::Config::PASSWORD3
    auth = Couch::Config::AUTH3


 #Put to server
   def self.putToServer(url,doc,auth,user,password,host,id)

     @uri = URI.parse(host + '/radiation-weather/'+id)

     http = Net::HTTP.new(host, 443);
     http.use_ssl = true
     req = Net::HTTP::Put.new('/radiation-weather/'+id,initheader ={'Authorization' => auth, 'Content-Type' => 'application/json' })
     req.body = doc
     req.basic_auth(user, password)
     res2 = http.request(req)
     unless ((res2.header).inspect) == "#<Net::HTTPOK 200 OK readbody=true>"
         puts (res2.header).inspect
         puts (res2.body).inspect
     end
     return http #res2
   end

   def self.httpGet(url,host,port)
     http = Net::HTTP.new(host, port)
     http.use_ssl = true
     request = Net::HTTP::Get.new(url)
     response = http.request(request)
     return response.body
   end

   #Get a timestamp - current time
   def self.timestamp()
      a = (Time.now).to_s
      b = a.split(" ")
      c = b[0].split("-")
      dt = DateTime.new(c[0].to_i, c[1].to_i, c[2].to_i, 12, 0, 0, 0)
      return dt.to_time.utc.iso8601
   end


     #Get ready to put into database
     server = Couch::Server.new(host, port)

     all_docs = httpGet("/radiation-weather/?q=&fields=id&format=json&limit=all",host,port)
     all_docs_json = JSON.parse(all_docs)
     ids =  all_docs_json['feed']['entries']

     ids.each do |id2|

        use_id = id2['id']

        #Fetch from database
        res = httpGet("/radiation-weather/"+use_id, host,port)
        entry = JSON.parse(res)

        #Create the json structure object
        entry['interval'] = Integer(entry['interval'])
        entry['updated'] = timestamp
        entry['updated_by'] = "siri.uldal@npolar.no"

        doc = entry.to_json
        puts use_id

        #post entry
        begin
         http = putToServer('https://' + host + '/radiation-weather/'+ use_id,doc,auth,user,password,host,use_id)
        end



     end

 end #module
end #class
