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
        puts x.to_s
        puts "--------------------"

        #Throw away old array
        @record_arr = []

      unless (x =~ /^\.\.?$/) #Drop . and .. dirs

        #There are two files Mast and Straaling
       CSV.foreach("./data/#{x}") do |row|
=begin
            #select all rows that starts with 20..
            if (row[0].match(/^20/))

            #Get uuid
            uuid = getUUID(server)
           # puts row[1].to_s + "***"

            @entry = {
                 :schema => 'http://api.npolar.no/schema/radiation-weather',
                 :collection => 'radiation-weather',
                 :id => uuid,
                 :_id => uuid,
                 :instrument_station => 'M KNG-6',
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
                 :q  => nil,
                 :created => timestamp,
                 :updated => timestamp,
                 :created_by => user,
                 :updated_by => user
            }


       CSV.foreach("./data/#{x}/1441_Npolar_Mast10min.dat") do |row2|



       #if row2[1] is equal to
       if (row[0].match(/^20/) && row[1] === row2[1])

            # puts row2[1].to_s + "***2"

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
    puts @entry[:record].to_s + @entry[:timestamp].to_s + " " + @entry[:id].to_s

    @record_arr.push(@entry[:record])

    #Post entry
    doc = @entry.to_json

    res2 = server.post("/weather-radiation/", doc, user, password)

    end #if
    end #CSV

    #Need to scan through file 1441_Npolar_Mast10min.dat if there are entries that do not exist in
    CSV.foreach("./data/#{x}/1441_Npolar_Mast10min.dat") do |row3|
       #if (row3[1].match(/^20/)

       #Compare file entries with array with entries from Straaling.
       res = @record_arr.select { |e| e == row3[1]}
       res.empty? {
             #Get uuid
            uuid = getUUID(server)
            puts row3[1].to_s + "   ANY"

            @entry = {
                 :schema => 'http://api.npolar.no/schema/radiation-weather',
                 :collection => 'radiation-weather',
                 :id => uuid,
                 :_id => uuid,
                 :instrument_station => 'M KNG-6',
                 :interval => '600',
                 :timestamp => row3[0][0..9] + 'T' + row[0][11..18] + 'Z', #trenger iso8601
                 :record => row3[1],
                 :battv => row3[2],
                 :ptemp_c => row3[3],
                 :battbankv_avg => row3[4],
                 :at_2_avg => row3[5],
                 :at_4_avg => row3[6],
                 :at_10_avg => row3[7],
                 :apogeefan_avg1 => row3[8],
                 :apogeefan_avg2 => row3[9],
                 :apogeefan_avg3 => row3[10],
                 :rh_2_avg => row3[11],
                 :rh_4_avg => row3[12],
                 :rh_10_avg => row3[13],
                 :p_sfc_avg => row3[14],
                 :ws_2_wvc1 => row3[15],
                 :ws_2_wvc2 => row3[16],
                 :ws_4_wvc1  => row3[17],
                 :ws_4_wvc2 => row3[18],
                 :ws_10_wvc1 => row3[19],
                 :ws_10_wvc2 =>  row3[20],
                 :gust_2_max =>  row3[21],
                 :gust_4_max  => row3[22],
                 :gust_10_max => row3[23],
                 :tcdt => row3[24],
                 :q  => row3[25],
                 :created => timestamp,
                 :updated => timestamp,
                 :created_by => user,
                 :updated_by => user
            }

            #remove nil values
            @entry.reject! {|k,v| v.nil?}

            #Post entry
            doc = @entry.to_json

            res2 = server.post("/weather-radiation/", doc, user, password)
       } #any
=end
    end #CSV


end #unless
} #for each


end #class
end #module
