#!/usr/bin/env ruby
# Update GeoJSON structure without altering the characters fixed from the old database.
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

  class FixGeoJSONSeabird

    #Set server
    host = Couch::Config::HOST4
    port = Couch::Config::PORT4
    password = Couch::Config::PASSWORD4
    user = Couch::Config::USER4
    auth = Couch::Config::AUTH4
    database = "seabird-colony"


    #Enforce right-hand rule: Sum over edges. (x2 − x1)(y2 + y1).
    #If the result is positive the curve is clockwise,
    #if it's negative the curve is counter-clockwise
    def self.rightHandRule(arr)
      size = arr.size
      sum = sum2 = 0
      for i in 0..(size-2)
          sum2 = (arr[i+1][0]-arr[i][0])*(arr[i+1][1] + arr[i][1])
          sum = sum + sum2
      end
      return sum
    end


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

      if @entry['latitude']

      #create a new geometry_collection
      geometry = @entry['geometry']

      #Found some errors with location_accuracy when Unknown - convert to lowercase letters
      if @entry['location_accuracy'].downcase == 'unknown'
          @entry['location_accuracy'].downcase!
      end


      #if we don't have a polygon, only use point
      @point = {
            :type => "Point",
            :coordinates => [@entry['longitude'],@entry["latitude"]]
      }


       @geometry_collection = @point


       #if we do have a polygon as well
       if @entry['geometry']

           @geo = @entry['geometry']['coordinates']

          #if they are not alike, add first coord to the last
           #according to RFC 7946
           unless @geo[0] &  @geo[@geo.length-1] == @geo[0]
             @entry['geometry']['coordinates'].push(@geo[0])
           end

           #Apply right-hand rule, go counterclockwise
           @shift_arr = []
           if rightHandRule(@geo) > 0
               for i in (@entry['geometry']['coordinates'].size-1).downto(0)
                  @shift_arr << @entry['geometry']['coordinates'][i]
               end
               @entry['geometry']['coordinates']=@shift_arr
            end


           @geometry = {
              :type => "Polygon",
              :coordinates => [@entry['geometry']['coordinates']]
           }

           @geometries = [ @point, @geometry ]

           @geometry_collection = {
              :type => "GeometryCollection",
              :geometries => @geometries
           }


       end

       #delete lat,lng
       @entry.tap { |k| k.delete("latitude") }
       @entry.tap { |k| k.delete("longitude") }
       @entry.tap { |k| k.delete("geometry") }
       @entry[:geometry] = @geometry_collection


       #remove nil values
       @entry.reject! {|k,v| v.nil?}

       #Post coursetype
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



end #class
end #module
