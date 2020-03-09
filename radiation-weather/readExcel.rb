#!/usr/bin/env ruby
# Read from the incoming Excel files and
# update the radiation-weather database
# pole KNG6.
#
#
# Author: srldl
#
# Requirements: Excel input file with new entries
#
########################################

require '../../config'
require '../../server'
require 'net/http'
require 'time'
require 'date'
require 'json'
require 'digest'
require 'spreadsheet'
require 'securerandom'
require 'fileutils'

module Couch

  class ReadExcel

    #Set server end destination
    host = Couch::Config::HOST4
    port = Couch::Config::PORT4
    user = Couch::Config::USER4
    password = Couch::Config::PASSWORD4
    auth = Couch::Config::AUTH4



 #Put to server
   def self.putToServer(url,doc,auth,user,password,host,id)

     @uri = URI.parse(host + '/radiation-weather/'+id)

     http = Net::HTTP.new(host, 443);
     http.use_ssl = true
     req = Net::HTTP::Put.new('/radiation-weather/'+id,initheader ={'Authorization' => auth, 'Content-Type' => 'application/json' })
     req.body = doc
     req.basic_auth(user, password)
     res2 = http.request(req)
     unless ((res2.header).inspect) == "#<Net::HTTPOK 200 OK readbody=true>" || ((res2.header).inspect) == "#<Net::HTTPCreated 201 Created readbody=true>"
         puts (res2.header).inspect
         puts (res2.body).inspect
         puts doc
     end
     return http #res2
   end

=begin
   def self.httpGet(url,host,port)
     http = Net::HTTP.new(host, port)
     http.use_ssl = true
     request = Net::HTTP::Get.new(url)
     response = http.request(request)
     return response.body
   end
=end

   #Get a timestamp - current time
   def self.timestamp()
      a = (Time.now).to_s
      b = a.split(" ")
      c = b[0].split("-")
      dt = DateTime.new(c[0].to_i, c[1].to_i, c[2].to_i, 12, 0, 0, 0)
      return dt.to_time.utc.iso8601
   end

   #Get hold of UUID for database storage
    def self.getUUID()
       return SecureRandom.uuid
    end

     #Get ready to put into database
     server = Couch::Server.new(host, port)

     # Open source spreadsheet - must be xls, NOT xlsx
     workbook = Spreadsheet.open './KNG20072016.xls'

     # Specify a single worksheet by index
     sheet1 = workbook.worksheet 'Sheet1'
     sheet1.each do |row|
       #puts "#{row[0]} - #{row[1]} - #{row[2]}"
        date1 = "#{row[0]}"
        use_id = getUUID()

           #Get a new id
           entry = {
                :id => use_id.to_s,
                :_id => use_id.to_s,
                :schema => 'http://api.npolar.no/schema/radiation-weather.json',
                :collection => 'radiation-weather',
                :instrument_station => 'AWS KNG-6',
                :interval => 3600,
                :timestamp => date1,
                :sw_in_wpm2_avg => (row[5] == 'NaN'? '':row[5].to_f),
                :sw_out_wpm2_avg => (row[6] == 'NaN'? '':row[6].to_f),
                :lw_out_corr_wpm2_avg => (row[8] == 'NaN'? '':row[8].to_f),
                :lw_in_corr_wpm2_std => (row[7] == 'NaN'? '':row[7].to_f),
                :at_2_avg => (row[1] == 'NaN'? '':row[1].to_f),
                :rh_2_avg => (row[2] == 'NaN'? '':row[2].to_f),
                :ws_2_wvc1 => (row[3] == 'NaN'? '':row[3].to_f),
                :ws_2_wvc2 => (row[4] == 'NaN'? '':row[4].to_f),
                :created => timestamp,
                :created_by => 'siri.uldal@npolar.no',
                :updated => timestamp,
                :updated_by => 'siri.uldal@npolar.no'
          }

        #Traverse @entry and remove all empty entries
        entry.each do | key, val |
          if  val == "" || val == nil
            entry.delete(key)
          end
        end

        doc = entry.to_json

        #post entry
        begin
         http = putToServer('https://' + host + '/radiation-weather/'+ use_id,doc,auth,user,password,host,use_id)
        end


end


 end #module
end #class
