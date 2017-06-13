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

  class ExcelStationBooking

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


    COUCH_DB_NAME = "radiation-weather"

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
    # while (line < ((s.last_row).to_i + 2))
     while (line < 9)

          #Get uuid
          uuid = getUUID(server)

          puts "count" + line.to_s
          timestamp = (s.cell(line, 1, 1))


          @entry = {
                 :schema => 'http://api.npolar.no/schema/radiation-weather',
                 :collection => 'radiation-weather',
                 :id => uuid,
                 :_id => uuid,
                 :instrument_id => 'instrument_id',
                 :interval => '1 hour',
                 :timestamp => timestamp.to_s[0..18] + 'Z', #trenger iso8601
                 :record => line,
                 :temp => s.cell(line, 2, 1),
                 :rh => s.cell(line, 3, 1),
                 :wind_min => s.cell(line, 4, 1),
                 :wind_max => s.cell(line, 5, 1),
                 :wind_mean => s.cell(line, 6, 1),
                 :wind_dir => s.cell(line, 7, 1),
                 :sw_in => s.cell(line, 8, 1),
                 :sw_out => s.cell(line, 9, 1),
                 :lw_out => s.cell(line, 10, 1),
                 :lw_in_ => s.cell(line, 11, 1)
            }

            #remove nil values
            @entry.reject! {|k,v| v.nil?}


            #Post @entry
            doc = @entry.to_json

            puts doc

            # res2 = server.post("/"+ Couch::Config::COUCH_SEABIRD + "/", doc, user, password)

            #Next line
            line = line+1

  end #while
end #excel_file

  end
end