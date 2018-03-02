#!/usr/bin/env ruby
# Fetch all entries from a datbase and move it to another one.
#
# Author: srldl
#
######################################################

require '../server'
require '../config'
require 'net/http'
require 'net/ssh'
require 'net/scp'
require 'time'
require 'date'
require 'json'


module Couch

  class MoveDatabase

    #Set server
    fetchHost = Couch::Config::HOST2
    fetchPort = Couch::Config::PORT2
    fetchPassword = Couch::Config::PASSWORD2
    fetchUser = Couch::Config::USER2

    #Post to server
    postHost = Couch::Config::HOST2
    postPort = Couch::Config::PORT2
    postPassword = Couch::Config::PASSWORD2
    postUser = Couch::Config::USER2

    #Get ready to put into database
    server = Couch::Server.new(fetchHost, fetchPort)
    server2 = Couch::Server.new(postHost, postPort)

    #Fetch from database
    db_res = server.get("/"+ Couch::Config::COUCH_PBHIMS_OLD + "/_all_docs")

    #Get ids
    res = JSON.parse(db_res.body)

    #Iterate over the Ids from Couch
    for i in 0..((res["rows"].size)-1)

      id =  res["rows"][i]["id"]


      db_old = server.get("/"+ Couch::Config::COUCH_PBHIMS_OLD + "/"+id)
      @db_old = JSON.parse(db_old.body)

      #Fetch the entry with the id from database incl attachments
      #db_entry = server.get("/"+ Couch::Config::COUCH_EXPEDITION + "/"+id+"?attachments=true")
      db_new = server2.get("/"+ Couch::Config::COUCH_PBHIMS_NEW + "/"+id)
      @entry = JSON.parse(db_new.body)
      @entry['db_comment'] = @db_old


      puts @entry


      #Need to remove revision - otherwise it will not save
    #  @entry.tap { |k| k.delete("_rev") }
    #  @entry.tap { |k| k.delete("_attachments") }

      #Post coursetype
      doc = @entry.to_json


     #Get new id
      db_res2 = server2.post("/"+ Couch::Config::COUCH_PBHIMS_NEW + "/", doc, postUser, postPassword, "application/json; charset=utf-8")
      id2 = JSON.parse(db_res2.body)
      puts id2
  #    rev = id2["rev"]
  #    length = id2["length"]

 end #iterate over ids

end #class
end #module
