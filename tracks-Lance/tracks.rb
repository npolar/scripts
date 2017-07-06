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

    #Convert lat/lng to decimaldegrees
    def self.decimaldegrees(str)
       #remove all leading 0, get degrees
       q=(str.to_f/100).to_i
       #get decimalpart
       m =(str.to_f/100).modulo(1)
       return m*100/60 + q
    end

    #read from met file
    def self.fetch_met(x)
       #Fetch file and lines based on current date
       cur_date = x[8..9] + x[5..6] + x[0..3]
       air_pressure = air_temperature = humidity = sea_temperature = 0

       File.open("./data/#{cur_date}met.txt").each do |q|


         #Split array into values
         q_arr = q.split(" ")

         if (q.match(/#{cur_date}/))
              timestamp = DateTime.parse(x,"%Y-%m-%dT%H:%M:%SZ")
              #Need to parse date
              dt =  q[10..13] + "-" + q[8..9] + "-" + q[6..7] + "T" + q[4..5] + ":" + q[2..3] + ":" + q[0..1] + "Z"
              cur_datetime =  DateTime.parse(dt,"%Y-%m-%dT%H:%M:%SZ")
              #As long as time is before our timestamp, keep updating all parameters
              #If we receive a datetime after, issue values
              if timestamp < cur_datetime
                 return  air_pressure, air_temperature, humidity, sea_temperature
              end
         elsif (q.match(/^04 Air temperature/))
            air_temperature = q_arr[3].to_f
         elsif (q.match(/^06 Relative humidity/))
            humidity = q_arr[3].to_f
         elsif (q.match(/^07 Air pressure/))
            air_pressure = q_arr[3].to_f
         elsif (q.match(/^08 S.water temperature/))
            sea_temperature = q_arr[3].to_f
         end

       end
    end

    #Read from depth file
    def self.fetch_depth(x)
      #Fetch file and lines based on current date
      cur_date = x[8..9] + x[5..6] + x[0..3]
      depth = 0

      begin
       file = File.open("./data/#{cur_date}depth.txt").each do |q|

          #Split array into values
          q_arr = q.split(",")
          #Need to parse date
          timestamp = DateTime.parse(x,"%Y-%m-%dT%H:%M:%SZ")
          dt =  q[10..13] + "-" + q[8..9] + "-" + q[6..7] + "T" + q[4..5] + ":" + q[2..3] + ":" + q[0..1] + "Z"
          cur_datetime =  DateTime.parse(dt,"%Y-%m-%dT%H:%M:%SZ")
          #As long as time is before our timestamp, keep updating all parameters
          #If we receive a datetime after, issue values
          if timestamp <= cur_datetime
                return  depth
          else
                depth = q_arr[4].to_f
          end

       end #file
      rescue
        #No depth file
        return nil
      ensure
        file.close unless file.nil?
      end

    end

    #Read from wind file
    def self.fetch_wind(x)
       #Fetch file and lines based on current date
       cur_date = x[8..9] + x[5..6] + x[0..3]
       wind_speed_mean = wind_direction_mean = 0

      begin
       file = File.open("./data/#{cur_date}wind.txt").each do |q|

          #Split array into values
          q_arr = q.split(",")
          #Need to parse date
          timestamp = DateTime.parse(x,"%Y-%m-%dT%H:%M:%SZ")
          dt =  q[10..13] + "-" + q[8..9] + "-" + q[6..7] + "T" + q[4..5] + ":" + q[2..3] + ":" + q[0..1] + "Z"
          cur_datetime =  DateTime.parse(dt,"%Y-%m-%dT%H:%M:%SZ")
          #As long as time is before our timestamp, keep updating all parameters
          #If we receive a datetime after, issue values
          if timestamp < cur_datetime
                return  wind_speed_mean, wind_direction_mean
          else
                wind_speed_mean = q_arr[4].to_f
                wind_direction_mean = q_arr[2].to_f
          end

       end #file
      rescue
        #No wind file
        return nil, nil
      ensure
        file.close unless file.nil?
      end
    end

    #Set server
    host = Couch::Config::HOST2
    port = Couch::Config::PORT2
    password = Couch::Config::PASSWORD2
    user = Couch::Config::USER2

    #Get ready to put into database:q!
    server = Couch::Server.new(host, port)

    #Timestamp
    a = (Time.now).to_s
    b = a.split(" ")
    c = b[0].split("-")
    dt = DateTime.new(c[0].to_i, c[1].to_i, c[2].to_i, 12, 0, 0, 0)
    timestamp = dt.to_time.utc.iso8601

    @entry = {
                 :id => '',
                 :_id => '',
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
                 :measured => '',
                 :object => "ship",
                 :platform => "RV Lance",
                 :sampling_rate => "60", #sampling each minute
                 :schema => "http://api.npolar.no/schema/expedition_track",
                 :sea_temperature => "",
                 :speed => "",
                 :updated => timestamp,
                 :updated_by => user,
                 :wind_direction_mean => "",
                 :wind_speed_mean => ""
    }


    Dir.foreach("./data") {|x|

        #If file .nav file
        if x == "#{x[0..7]}nav.txt"

               #Extract info from nav file, do not repeat the same timestamp more than once
               previous = "0"

            File.open("./data/#{x[0..7]}nav.txt").each do |p|

                 #Sample every minute, discard other samples
                 if ((p.match(/^00/)) && (p.to_s != previous.to_s))
                    #Make sure the same time is not sampled twice
                    previous = p
                    @entry[:measured] = p[10..13] + "-" + p[8..9] + "-" + p[6..7] + "T" + p[4..5] + ":" + p[2..3] + ":" + p[0..1] + "Z"

                    #Get uuid
                    uuid = getUUID(server)
                    @entry[:id] = uuid
                    @entry[:_id] = uuid


                    if  ((Date.parse(p[6..7]+"/"+p[8..9]+"/"+p[10..13])).between?(Date.parse("30/03/2017"),Date.parse("20/04/2017")))
                      puts "slected"
                      @entry[:code] = "polar bear monitoring MOSJ"
                      @entry[:expedition] = "https://data.npolar.no/expedition/8b4b8b5c-7261-4abd-a56b-37cbbc078e38"
                    else #else "ICE-Whales"
                      @entry[:code] = "ICE-Whales"
                      @entry[:expedition] = "https://data.npolar.no/expedition/fcf8bad7-2b0a-47a7-bb97-9115d8855638"
                    end

                    #Fetch values from other files here
                    @entry[:air_pressure], @entry[:air_temperature], @entry[:humidity], @entry[:sea_temperature] = fetch_met(@entry[:measured].to_s)
                    @entry[:depth] = fetch_depth(@entry[:measured].to_s)
                    @entry[:wind_speed_mean], @entry[:wind_direction_mean] = fetch_wind(@entry[:measured].to_s)

                    #remove nil values
                    @entry.reject! {|k,v| v.nil?}

                    #Post entry
                    doc = @entry.to_json
                    puts doc

                    res2 = server.post("/expedition_track/", doc, user, password)

                 elsif (p.match(/^\$INVTG/))
                    q = p.split(",")
                    @entry[:course] = q[1].to_f
                    @entry[:speed] = q[5].to_f
                 elsif (p.match(/^\$INGGA/))
                    q = p.split(",")
                    @entry[:latitude] = decimaldegrees(q[2]) #Conversion to decimal degrees
                    @entry[:longitude] = q[5] == 'E'? decimaldegrees(q[4]) : (-1)*decimaldegrees(q[4]) #Conversion to decimal degrees

                 else
                    # do nothing
                  end
               end

             #  file.close

        end
    }




end #class
end #module
