#!/usr/bin/env ruby
# Read track files from Lance to database.
#
# Author: srldl
#
########################################

require '../server'
require '../config'
require 'net/http'
require 'net/ssh'
require 'net/scp'
require 'csv'
require 'time'
require 'date'
require 'json'


module Couch

  class Tracks

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
    host = Couch::Config::HOST1
    port = Couch::Config::PORT1
    password = Couch::Config::PASSWORD1
    user = Couch::Config::USER1

    #Get ready to put into database:q!
    server = Couch::Server.new(host, port)

    #Timestamp
    a = (Time.now).to_s
    b = a.split(" ")
    c = b[0].split("-")
    dt = DateTime.new(c[0].to_i, c[1].to_i, c[2].to_i, 12, 0, 0, 0)
    timestamp = dt.to_time.utc.iso8601

    @entry = Hash.new

    Dir.foreach("./data") {|x|

        #If file .nav file
        if x == "#{x[0..7]}nav.txt"

               #Extract info from nav file
               previous = "0"
               CSV.foreach("./data/#{x[0..7]}nav.txt") do |nav|

                  #Sample every min. Select all rows that starts with 00..
                  if (nav[0].match(/^00/)) && (nav[0] != previous)
                      previous = nav[0]
                      puts nav[0]
                  end
               end

               #Extract info from met file
=begin              CSV.foreach("./data/#{x[0..7]}met.txt") do |met|
                  #Find value closest to sampling time
                  puts met.to_s + "  ccccc"
               end

               begin
                    #Extract info from depth file
                    CSV.foreach("./data/#{x[0..7]}depth.txt") do |depth|
                           #Find value closest to sampling time
                          puts depth.to_s + "  ccccc"
                    end
               ensure
               end

               begin
                    #Extract info from wind file
                    CSV.foreach("./data/#{x[0..7]}wind.txt") do |wind|
                           #Find value closest to sampling time
                          puts wind.to_s + "  ccccc"
                    end
                ensure
                end
=end

               abort("ending")

            #Get uuid
            uuid = getUUID(server)

            #If date between 30.05 and 20.04 it is the "polar bear monitoring MOSJ" exped
            if  (Date.parse(x[0..1]+"/"+x[2..3]+"/"+x[4..7])).between?(Date.parse("20/04/2017"),Date.parse("30/03/2017"))
              @code = "polar bear monitoring MOSJ"
              @expedition = "https://data.npolar.no/expedition/8b4b8b5c-7261-4abd-a56b-37cbbc078e38"
            else #else "ICE-Whales"
              @code = "ICE-Whales"
              @expedition = "https://data.npolar.no/expedition/fcf8bad7-2b0a-47a7-bb97-9115d8855638"
            end


            @entry = {
                 :id => uuid,
                 :_id => uuid,
                 :air_pressure => '',
                 :air_temperature => '',
                 :code => @code,
                 :collection => 'track',
                 :course => '',
                 :created => timestamp,
                 :created_by => user,
                 :depth => '',
                 :expedition => @expedition,
                 :humidity => '',
                 :latitude => '',
                 :longitude => '',
                 :measured => 'time----',
                 :object => "ship",
                 :platform => "RV Lance",
                 :sampling_rate => "",
                 :schema => "http://api.npolar.no/schema/expedition_track",
                 :sea_temperature => "",
                 :speed => "",
                 :updated => timestamp,
                 :updated_by => user,
                 :wind_direction_mean => "",
                 :wind_speed_mean => ""
            }

            #Get met.txt file

            #Get depth.txt file -if existing

            #Get wind.txt - if existing


            #remove nil values
            @entry.reject! {|k,v| v.nil?}

            #Post entry
            doc = @entry.to_json
            puts doc

           # res2 = server.post("/expedition_track/", doc, user, password)

    end #if
} #for each


end #class
end #module
