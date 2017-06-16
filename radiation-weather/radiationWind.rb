#!/usr/bin/env ruby
# Read from the radioation-wind files to the radiation weather database
#
# Author: srldl
#
# Requirements:
#
########################################

require '../config'
require '../server'
require 'net/http'
require 'net/ssh'
require 'time'
require 'date'
require 'json'
require 'simple-spreadsheet'



module Couch

  class RadiationWind

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
    user = Couch::Config::USER1
    password = Couch::Config::PASSWORD1

    title = ""

    # do work on files ending in .xls in the desired directory
    Dir.glob('./data/*.xlsx') do |excel_file|


     #Open the file
     s = SimpleSpreadsheet::Workbook.read(excel_file)

     #Always fetch the first sheet
     s.selected_sheet = s.sheets.first

     #Start down the form -after
     line = 3
     last = (s.last_row).to_i

     people = Array.new

     #Get ready to put into database
     server = Couch::Server.new(host, port)

     #Count down the lines
     while (line < ((s.last_row).to_i + 2))
    # while (line < 9)

          #Get uuid
          uuid = getUUID(server)

          puts "count" + line.to_s
          timestamp = (s.cell(line, 1, 1))


          @entry = {
                 :schema => 'http://api.npolar.no/schema/radiation-weather',
                 :collection => 'radiation-weather',
                 :id => uuid,
                 :_id => uuid,
                 :instrument_station => 'AWS KNG-6',
                 :interval => '3600',
                 :timestamp => timestamp.to_s[0..18] + 'Z', #trenger iso8601
                 :record => line,
                 :at_2_avg => (s.cell(line, 2, 1)).round(1),
                 :rh_2_avg => (s.cell(line, 3, 1)).round(1),
                 :ws_2_min => unless (s.cell(line, 4, 1) == 'NaN') then  (s.cell(line, 4, 1)).round(1) end ,
                 :gust_2_max => unless (s.cell(line, 5, 1) == 'NaN') then  (s.cell(line, 5, 1)).round(1) end ,
                 :ws_2_wvc1 => unless (s.cell(line, 6, 1) == 'NaN') then (s.cell(line, 6, 1)).round(1) end,
                 :ws_2_wvc2 => unless (s.cell(line, 7, 1) == 'NaN') then (s.cell(line, 7, 1)).round(1) end,
                 :sw_in_wpm2_avg => (s.cell(line, 8, 1)).round(1),
                 :sw_out_wpm2_avg => (s.cell(line, 9, 1)).round(1),
                 :lw_in_corr_wpm2_avg => (s.cell(line, 10, 1)).round(1),
                 :lw_out_corr_wpm2_avg => (s.cell(line, 11, 1)).round(1)
          }

          #remove nil values
          @entry.reject! {|k,v| v.nil?}

          #Post @entry
          doc = @entry.to_json

          #puts doc

          res2 = server.post("/radiation-weather/", doc, user, password)

          #Next line
          line = line+1

  end #while
end #excel_file

  end
end
