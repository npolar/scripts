#!/usr/bin/env ruby
# Convert from 10min radiation-weather data into the 1 hourRadiation-weather database
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
    pi = 3.14159

    Dir.foreach("./data") {|x|

        #Throw away old array
        @record_arr = Array.new(16, 0)

      unless ((x =~ /^\.\.?$/) && (!x.start_with? '2017')) #Drop . and .. dirs, start with 2017

        #Initialization - @hour holds the current hour
        @hour = 25
        @at_2_avg =  @rh_2_avg = @ws_2_wvc1 = @ws_2_wvc2 = @sw_in_wpm2_avg = 0
        @sw_out_wpm2_avg = @lw_in_corr_wpm2_avg = @lw_out_corr_wpm2_avg = 0
        @count = 0

       #There are two files Mast and Straaling
       CSV.foreach("./data/#{x}/1441_Npolar_Straaling10min.dat") do |row|

            #select all rows that starts with 20..
            if (row[0].match(/^20/))

                @row2 = []

                puts "____________________"
                puts row[0][0..9] + 'T' + row[0][11..18] + 'Z'

                #read the whole schema
                CSV.foreach("./data/#{x}/1441_Npolar_Straaling10min.dat") do |row3|
                    if row3[1] ==row[1]
                        @row2 = row3
                    end
                end


                #Get all 6 of samples within an hour, summarize them
                if  (row[0][11..12] == @hour ) || ((@at_2_avg == 0) && (@rh_2_avg == 0) && (@ws_2_wvc1 == 0) && (@ws_2_wvc2 == 0) && (@sw_in_wpm2_avg == 0) && (@sw_out_wpm2_avg == 0) && (@lw_in_corr_wpm2_avg == 0) && (@lw_out_corr_wpm2_avg == 0))

                    #Get the variables
                    @at_2_avg = @at_2_avg + @row2[5].to_f
                    puts @at_2_avg
                    @rh_2_avg = @rh_2_avg + @row2[11].to_f
                    #The min form 10 min data is not the same as the min from 60 min data which is samples every 30 sek!
                    #Thus, exclude @ws_2_min and @gust_2_max
                    @ws_2_wvc1 = @ws_2_wvc1 + @row2[15].to_f

                    @ws_2_wvc2sin =  (sin(@row2[16].to_f * pi/180) + @ws_2_wvc2
                    @ws_2_wvc2cos =  (cos(@row2[16].to_f * pi/180) + @ws_2_wvc2

                    @sw_in_wpm2_avg = @sw_in_wpm2_avg + row[2].to_f
                    @sw_out_wpm2_avg = @sw_out_wpm2_avg + row[4].to_f
                    @lw_in_corr_wpm2_avg = @lw_in_corr_wpm2_avg + row[3].to_f
                    @lw_out_corr_wpm2_avg = @lw_out_corr_wpm2_avg + row[5].to_f

                    #@count holds the number for averaging
                    @count= @count+1

                else

                    #Est the wind direction, ws_2_wvc2
                    u_east = @ws_2_wvc2sin/@count
                    u_north = @ws_2_wvc2cos/@count
                    unit_WD = atan2(u_east, u_north) * 180/pi
                    sum_ws_2_wvc2 = (360 + unit_WD) % 360

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
                        :record => row[1], #mean from
                        :at_2_avg => @at_2_avg/@count,
                        :rh_2_avg => @rh_2_avg/@count,
                        :ws_2_wvc1 => @ws_2_wvc1/@count,
                        :ws_2_wvc2 => sum@ws_2_wvc2,
                        :sw_in_wpm2_avg => @sw_in_wpm2_avg/@count,
                        :sw_out_wpm2_avg => @sw_out_wpm2_avg/@count,
                        :lw_in_corr_wpm2_avg => @lw_in_corr_wpm2_avg/@count,
                        :lw_out_corr_wpm2_avg => @lw_out_corr_wpm2_avg/@count,
                        :created => timestamp,
                        :updated => timestamp,
                        :created_by => user,
                        :updated_by => user
                    }


                    #remove nil values
                    @entry.reject! {|k,v| v.nil?}
                    puts @entry

                    #Post entry
                  #  doc = @entry.to_json
                  #  res2 = server.post("/weather-radiation/", doc, user, password)

                    @at_2_avg =  @rh_2_avg = @ws_2_wvc1 = @ws_2_wvc2 = @sw_in_wpm2_avg = 0
                    @sw_out_wpm2_avg = @lw_in_corr_wpm2_avg = @lw_out_corr_wpm2_avg = @count = 0

                end

                #Update @hour to current hour of the day
                @hour = row[0][11..12]

    end #if
    end #CSV

end #unless
} #for each


end #class
end #module
