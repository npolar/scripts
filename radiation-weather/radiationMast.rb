#!/usr/bin/env ruby
# Convert from 10min radiationWeather data into the Radiation-weather database
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

  class RadiationMast

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



    #Get ready to put into database
    server = Couch::Server.new(host, port)

    #Timestamp
    a = (Time.now).to_s
    b = a.split(" ")
    c = b[0].split("-")
    dt = DateTime.new(c[0].to_i, c[1].to_i, c[2].to_i, 12, 0, 0, 0)
    timestamp = dt.to_time.utc.iso8601

    @entry = Hash.new

    Dir.foreach("./data") {|x|
      unless (x =~ /^\.\.?$/) #Drop . and .. dirs

       #arr_mast holds all record values that exists in both files
       @arr_mast = []

        #There are two files Mast and Straaling
       CSV.foreach("./data/#{x}/1441_Npolar_Mast10min.dat") do |row|
      # CSV.foreach("./data/20170506_1/1441_Npolar_Straaling10min.dat") do |row|
            #Get uuid
            uuid = getUUID(server)



            #select all rows that starts with 20..
            if (row[0].match(/^20/))


            @entry = {
                 :schema => 'http://api.npolar.no/schema/radiation-weather',
                 :collection => 'radiation-weather',
                 :id => uuid,
                 :_id => uuid,
                 :instrument_id => 'instrument_id',
                 :interval => '600',
                 :timestamp => row[0][0..9] + 'T' + row[0][11..18] + 'Z', #trenger iso8601
                 :record => row[1],
                 :sw_in_wpm2_avg => row[2],
                 :lw_in_corr_wpm2_avg => row[3],
                 :sw_out_wpm2_avg => row[4],
                 :lw_out_corr_wpm2_avg => row[5],
                 :sw_in_t_c_avg => row[6],
                 :lw_in_t_c_avg => row[7],
                 :sw_out_t_c_avg => row[8],
                 :lw_out_t_c_avg => row[9],
                 :sw_in_fan_hz_avg => row[10],
                 :lw_in_fan_hz_avg => row[11],
                 :sw_out_fan_hz_avg => row[12],
                 :lw_out_fan_hz_avg => row[13],
                 :sw_in_wpm2_std => row[14],
                 :lw_in_corr_wpm2_std => row[15],
                 :sw_out_wpm2_std => row[16],
                 :lw_out_corr_wpm2_std => row[17],
                 :battv => nil,
                 :ptemp_c => nil,
                 :battbankv_avg => nil,
                 :at_2_avg => nil,
                 :at_4_avg => nil,
                 :at_10_avg => nil,
                 :apogeefan_avg1 => nil,
                 :apogeefan_avg2 => nil,
                 :apogeefan_avg3 => nil,
                 :rh_2_avg => nil,
                 :rh_4_avg => nil,
                 :rh_10_avg => nil,
                 :p_sfc_avg => nil,
                 :ws_2_wvc1 => nil,
                 :ws_2_wvc2 => nil,
                 :ws_4_wvc1  => nil,
                 :ws_4_wvc2 => nil,
                 :ws_10_wvc1 => nil,
                 :ws_10_wvc2 => nil,
                 :gust_2_max => nil,
                 :gust_4_max  => nil,
                 :gust_10_max => nil,
                 :tcdt => nil,
                 :q  => nil
            }
            end #if

       CSV.foreach("./data/20170506_1/1441_Npolar_Mast10min.dat") do |row2|

       #if row2[1] is equal to



       if (row[0].match(/^20/) && row[1] === row2[1])

             @entry[:battv] = row2[2]
             @entry[:ptemp_c] = row2[3]
             @entry[:battbankv_avg] = row2[4]
             @entry[:at_2_avg] = row2[5]
             @entry[:at_4_avg] = row2[6]
             @entry[:at_10_avg] = row2[7]
             @entry[:apogeefan_avg1] = row2[8]
             @entry[:apogeefan_avg2] = row2[9]
             @entry[:apogeefan_avg3] = row2[10]
             @entry[:rh_2_avg] = row2[11]
             @entry[:rh_4_avg] = row2[12]
             @entry[:rh_10_avg] = row2[13]
             @entry[:p_sfc_avg] = row2[14]
             @entry[:ws_2_wvc1] = row2[15]
             @entry[:ws_2_wvc2] = row2[16]
             @entry[:ws_4_wvc1]  = row2[17]
             @entry[:ws_4_wvc2] = row2[18]
             @entry[:ws_10_wvc1] = row2[19]
             @entry[:ws_10_wvc2] =  row2[20]
             @entry[:gust_2_max] =  row2[21]
             @entry[:gust_4_max]  = row2[22]
             @entry[:gust_10_max] = row2[23]
             @entry[:tcdt] = row2[24]
             @entry[:q]  = row2[25]
       end
     end #CSV

    #remove nil values
    @entry.reject! {|k,v| v.nil?}

    #Skip if empty!!
    puts @entry[:record]
    puts @entry[:timestamp]



    #Post entry
    doc = @entry.to_json

    res2 = server.post("/weather-radiation/", doc, user, password)

    end #CSV

end #unless
} #for each


end #class
end #module
