'use strict';

   //Read file
   var fs = require('fs');
   var md5 = require('md5');
   var mime = require('mime-types');
   var request = require('request');
   var Rsync = require('rsync');
   var XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest;
   var xhr = new XMLHttpRequest();

   //Get file metadata
   var filename = 'MOSJ_data_HR.xlsx';
   var size = 0;
   let fd,fd2;

   //Decided to go for synchronous because if if fails, the script should terminate since I have no uuid
   xhr.open("GET", "http://db-test.data.npolar.no:5984/_uuids",false);
   xhr.send(null);

   if (xhr.status === 200) {
      var ret = JSON.parse(xhr.responseText);
      var uuid = ret['uuids'][0];
      //console.log("uuid",uuid);

    //Want to run this synchronously
    try {
      fd = fs.openSync('./files/'+filename, 'r');
      size = (fs.fstatSync(fd)).size;

      //Add to log files
      fs.appendFileSync('./log', uuid+"/"+filename+",");

      //  console.log("file size",size);
    } catch (err) {
      /* Handle the error */
      console.log("Error - did not find file size!!");
    } finally {
      if (fd !== undefined)
        fs.closeSync(fd);
    }

    let mimetype = mime.lookup('./files/'+filename);
    //console.log(mimetype);



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
     //Store file on disk
     var rsync = Rsync.build({
        source:      './files/'+filename,
        destination: 'app-test.data.npolar.no:dist/'+filename,
        flags:       'avz',
        shell:       'ssh'
    });

rsync.execute(function(error, stdout, stderr) {
  // we're done
  console.log(error, stdout, stderr);
});

     //Store info in couchdb as ecotox-excel.json

  /*   var options = {
        url: "http://db-test.data.npolar.no:5984/ecotox-excel/"+uuid,
        method: "POST",
        headers: {
          'Content-type': 'application/json'
        },
        body: '{ "username": "vvvvv", "password": "mmmmmm", "body":"pppp"}'
      };

function callback(error, response, body) {
  console.log("callback function");
  if (!error) {
    var info = (JSON.parse(body));
    console.log(info);
    console.log("status 200");

  }
  else {
    console.log(JSON.parse(body));
  }
}

request.post(options, callback); */

//write uuid to log file





 } //uuid returns
