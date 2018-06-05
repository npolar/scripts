'use strict';

   //Get  libraries
   var fs = require('fs');
   var md5 = require('md5');
   var mime = require('mime-types');
   var request = require('request');
   var Rsync = require('rsync');
   var XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest;


   //Get file metadata
   var filename = 'MOSJ_data_HR.xlsx';
   var size = 0;
   let fd,fd2;
   let uuid;

   //Decided to go for synchronous because if if fails, the script should terminate since I have no uuid
   let xhr = new XMLHttpRequest();
   xhr.open("GET", "http://db-test.data.npolar.no:5984/_uuids",false);
   xhr.send(null);

   if (xhr.status === 200) {
      var ret = JSON.parse(xhr.responseText);
      uuid = ret['uuids'][0];
      console.log("uuid",uuid);

    //Create a log file which contains all uuid-name connections
    //Want to run this synchronously
    try {
      fd = fs.openSync('./files/'+filename, 'r');
      size = (fs.fstatSync(fd)).size;

      //Add to log files
      fs.appendFileSync('./log', uuid+":"+filename+",");

      //  console.log("file size",size);
    } catch (err) {
      /* Handle the error */
      console.log("Error - did not find file size!!");
    } finally {
      if (fd !== undefined)
        fs.closeSync(fd);
    }

    //Get the MIME type
    let mimetype = mime.lookup('./files/'+filename);

    //Create object for json file
    var entry = {
        id:uuid,
        schema:"http://api.npolar.no/schema/ecotox-excel",
        base:"http://api.npolar.no",
        language: "en",
        collection: "ecotox-excel",
        uri:"https://api.npolar.no/ecotox-excel/" + uuid + "/_file/" + filename,
        filename: filename,
        length:  size,
        type: mimetype,
        hash: md5(filename),
      //comments:
        created: new Date().toISOString(),
        updated: new Date().toISOString(),
        created_by:"siri.uldal@npolar.no",
        updated_by:"siri.uldal@npolar.no",
        _id:uuid
     };

     console.log(entry);

     let json_entry = JSON.stringify(entry);
     console.log(typeof json_entry);

     //Store file on disk
/*     var rsync = Rsync.build({
        source:      './files/'+filename,
        destination: 'app-test.data.npolar.no:dist/'+filename,
        flags:       'avz',
        shell:       'ssh'
    });

rsync.execute(function(error, stdout, stderr) {
  // we're done
  console.log(error, stdout, stderr);
}); */

   //Store info in couchdb as ecotox-excel.json
  // let username = "john";
  // let password = "1234";
   let url = 'http://db-test.data.npolar.no:5984/ecotox/'+uuid;
   //let url = 'http://db-test.data.npolar.no:5984/ecotox/dbbaa37369e6c7009614cef0f502307c';
   //let url = 'https://api-test.data.npolar.no:5984/ecotox/'+uuid;
  // let auth = "Basic " + new Buffer(username + ":" + password).toString("base64");

request(
   {
       method: 'PUT',
       url : url
    //   auth: auth
  //     headers : {
        //   "Authorization" : auth,
      //  'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
  //      'Content-Type': 'application/json',
  //      'Accept': 'application/json',
  //    }
      , multipart:
      [ {
           'content-type': 'application/json'
        ,  body: JSON.stringify(entry)
        }
        ,
      ]
   },
   function (error, response, body) {
      console.log(error,response, body);
      // Do more stuff with 'body' here
   }
);

} //uuid returns
