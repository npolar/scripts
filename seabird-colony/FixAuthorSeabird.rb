#!/usr/bin/env ruby
# Update database to not contain NP not to be cited without permission.
#
# Author: srldl
#
########################################

require '../server'
require '../config'
require 'net/http'
require 'net/ssh'
require 'net/scp'
require 'mdb'
require 'time'
require 'date'
require 'json'
require 'openssl'


module Couch

  class FixAuthorSeabird

    #Set server
    host = Couch::Config::HOST4
    port = Couch::Config::PORT4
    password = Couch::Config::PASSWORD4
    user = Couch::Config::USER4
    auth = Couch::Config::AUTH4
    database = "seabird-colony"


    #Get ready to put into database
    server = Couch::Server.new(host, port)

    #Fetch a UUIDs from couchdb
    db_res = server.get("/"+ database + "/?q=&fields=_id&format=json&variant=array&limit=all")

    #Get ids
    res = JSON.parse(db_res.body)

    #Iterate over the Ids from Couch
    for i in 0..((res.size)-1)

      id =  res[i]["_id"]

      #Fetch the entry with the id from database
      db_entry = server.get("/"+ database + "/"+id)
      @entry = JSON.parse(db_entry.body)

      doc = {}

      if @entry['colony_reference']
        if @entry['colony_reference']['authors'] == "NP, not to be cited without permission"
             @entry['colony_reference']['authors'] = "NP internal reference"
              #puts @entry
              doc = @entry.to_json
              puts doc
              #Post to server
              #@uri = URI.parse('http://api-test.data.npolar.no/seabird-colony')
              @uri = URI.parse('http://api.npolar.no/seabird-colony')
              http = Net::HTTP.new(@uri.host, @uri.port)
              req = Net::HTTP::Post.new(@uri.path,{'Authorization' => auth, 'Content-Type' => 'application/json' })
              req.body = doc
              req.basic_auth(user, password)
              res2 = http.request(req)
              puts (res2.header).inspect

             # puts (res2.body).inspect
          end
      end

       #Post coursetype




    end



end #class
end #module
