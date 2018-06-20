//0. Compare
//1. Upload file to archive - readExcel
//2. Create preliminary excel file - prepareEcotox
//3. Read from manually prepared file back to database EcotoxToDB

//js-xlsx
//Get file metadata
var fs = require('fs');
var files = fs.readdirSync('./files/');
var filename = 'log';
var readfile = '';

   fs.readFile('./'+filename, 'utf8', function (err,data) {
     if (err) {
        return console.log(err);
     }
     readfile = data;
    // console.log(readfile);

     //Scan log file for text
     for (i=0;i<files.length;i++){
        //Replace space with underscore - needed for file storage
        var file1 = files[i].replace(/ /g,"_");
        console.log("----------------------------")
        console.log(file1);

        if (readfile.includes(file1)){
          console.log(file1);
        }
    }; //for

  });
