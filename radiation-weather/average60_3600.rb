#!/usr/bin/env ruby
# Convert from 10min radiationWeather data into the 1 hourRadiation-weather database
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

  class Average60_3600

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

        #Throw away old array
        @record_arr = []

      unless ((x =~ /^\.\.?$/) && (!x.start_with? '2017')) #Drop . and .. dirs, start with 2017

       #There are two files Mast and Straaling
       CSV.foreach("./data/#{x}/1441_Npolar_Straaling10min.dat") do |row|

            @hour = 25

            #select all rows that starts with 20..
            if (row[0].match(/^20/))

                #read the whole schema
                row2 = CSV.read("./data/#{x}/1441_Npolar_Mast10min.dat")
                puts row2.type
                #Search a string for the right date
                end
                ....

                 #Get all 6 of them
                if  row[0][11..12] == @hour

                    #Get the variables
                    @at_2_avg = @at_2_avg + row2[5],
                    @rh_2_avg = @rh_2_avg + row2[11]
                    @ws_2_min = @ws_2_min +
                    @gust_2_max = @gust_2_max + row2[21]
                    @ws_2_wvc1 = @ws_2_wvc1 + row2[15]
                    @ws_2_wvc2 = @ws_2_wvc2 + row2[16]
                    @sw_in_wpm2_avg = @sw_in_wpm2_avg + row[2]
                    @sw_out_wpm2_avg = @sw_out_wpm2_avg + row[4]
                    @lw_in_corr_wpm2_avg = @lw_in_corr_wpm2_avg + row[3]
                    @lw_out_corr_wpm2_avg = @lw_out_corr_wpm2_avg + row[5]

                elsif @hour == 25

                    u_east = mean(sin(WD * pi/180))
                    u_north = mean(cos(WD * pi/180))
                    avg_WD = arctan2(u_east, u_north) * 180/pi
                    avg_WD = (360 + unit_WD) % 360

                    #Get uuid
                    uuid = getUUID(server)

                    @entry = {
                        :schema => 'http://api.npolar.no/schema/radiation-weather',
                        :collection => 'radiation-weather',
                        :id => uuid,
                        :_id => uuid,
                        :instrument_station => 'AWS KNG-6',
                        :interval => '3600',
                        :timestamp => row[0][0..9] + 'T' + row[0][11..18] + 'Z', #trenger iso8601
                        :record => row[1],
                        :at_2_avg => ,
                        :rh_2_avg => ,
                        :ws_2_min => ,
                        :gust_2_max => ,
                        :ws_2_wvc1 => ,
                        :ws_2_wvc2 => ,
                        :sw_in_wpm2_avg => ,
                        :sw_out_wpm2_avg =>  ,
                        :lw_in_corr_wpm2_avg => ,
                        :lw_out_corr_wpm2_avg => ,
                        :created => timestamp2,
                        :updated => timestamp2,
                        :created_by => user,
                        :updated_by => user
                    }

                    #remove nil values
                    @entry.reject! {|k,v| v.nil?}

                    #Post entry
                  #  doc = @entry.to_json
                  #  res2 = server.post("/weather-radiation/", doc, user, password)
                end

    end #if
    end #CSV

end #unless
} #for each


end #class
end #module
