#!/usr/bin/env ruby
# Convert from colony Access database to the new couchdb database
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
#require 'dir'
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


   ## Dir.foreach("./data") {|x|
   ##   unless (x =~ /^\.\.?$/)


         #Using mdb which lacks the ability to do sql search
      # CSV.foreach("./data/#{x}/1441_Npolar_Mast10min.dat") do |row|
       CSV.foreach("./data/20170506_1/1441_Npolar_Mast10min.dat") do |row|
            #Get uuid
            uuid = getUUID(server)

            if (row[0].match(/^20/))

            @entry = {
                 :schema => 'http://api.npolar.no/schema/radiation-mast',
                 :collection => 'radiation-mast',
                 :id => uuid,
                 :_id => uuid,
                 :instrument_id => 'instrument_id',
                 :interval => '10 min',
                 :timestamp => row[0], #trenger iso8601
                 :record => row[1],
                 :battv => row[2],
                 :ptemp_c => row[3],
                 :battbankv_avg => row[4],
                 :at_2_avg => row[5],
                 :at_4_avg => row[6],
                 :at_10_avg => row[7],
                 :apogeefan_avg1 => row[8],
                 :apogeefan_avg2 => row[9],
                 :apogeefan_avg3 => row[10],
                 :rh_2_avg => row[11],
                 :rh_4_avg => row[12],
                 :rh_10_avg => row[13],
                 :p_sfc_avg => row[14],
                 :ws_2_wvc1 => row[15],
                 :ws_2_wvc2 => row[16],
                 :ws_4_wvc1  => row[17],
                 :ws_4_wvc2 => row[18],
                 :ws_10_wvc1 => row[19],
                 :ws_10_wvc2 => row[20],
                 :gust_2_max => row[21],
                 :gust_4_max  => row[22],
                 :gust_10_max => row[23],
                 :tcdt => row[24],
                 :q  => row[25]
              }
            end #if

       CSV.foreach("./data/20170506_1/1441_Npolar_Straaling10min.dat") do |row2|

       #if row[0] starts with 20, i is ok
       if (row2[0].match(/^20/)) && (row[1] === row2[1])


              @entry = {
                 :battv => row2[2],
                 :ptemp_c => row2[3],
                 :battbankv_avg => row2[4],
                 :at_2_avg => row2[5],
                 :at_4_avg => row2[6],
                 :at_10_avg => row2[7],
                 :apogeefan_avg1 => row2[8],
                 :apogeefan_avg2 => row2[9],
                 :apogeefan_avg3 => row2[10],
                 :rh_2_avg => row2[11],
                 :rh_4_avg => row2[12],
                 :rh_10_avg => row2[13],
                 :p_sfc_avg => row2[14],
                 :ws_2_wvc1 => row2[15],
                 :ws_2_wvc2 => row2[16],
                 :ws_4_wvc1  => row2[17],
                 :ws_4_wvc2 => row2[18],
                 :ws_10_wvc1 => row2[19],
                 :ws_10_wvc2 => row2[20],
                 :gust_2_max => row2[21],
                 :gust_4_max  => row2[22],
                 :gust_10_max => row2[23],
                 :tcdt => row2[24],
                 :q  => row2[25]
              }
       end
     end #CSV
        #  p = row.inspect
        #  puts p.type
        #  puts p[1]
    #remove nil values
   # @colony_obj.reject! {|k,v| v.nil?}

    #Post coursetype
   # doc = @colony_obj.to_json

   # res2 = server.post("/"+ Couch::Config::COUCH_SEABIRD + "/", doc, user, password)

puts @entry

       end #CSV


 #     end #unless
 #   } #dir


end #class
end #module
