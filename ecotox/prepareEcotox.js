//js-xlsx
   XLSX = require('xlsx');
   var fs = require('fs');
   var filename = 'OC\ kylling\ blod\ 99.xls';


  /*write to csv file */
  function convertToCSV(objArray) {
       var obj = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
       var str = 'spreadsheet | id | date | lat | lng | expedition | sample_method \r\n';

    //   for (var i = 0; i < Object.keys(obj).length; i++) {
           var line = '';
           for (var key in obj){
             var attrName = key;
             var attrValue = obj[key];
              console.log(attrName, attrValue);
              line += attrValue + "|";
           }
           str += line + '\r\n';
    //   }
       return str;
  }

   var workbook = XLSX.readFile(filename);

   var first_sheet_name = workbook.SheetNames[0];
   var address_of_cell = 'A1';

   /* Get worksheet */
   var worksheet = workbook.Sheets[first_sheet_name];

   /* Find desired cell */
   var desired_cell = worksheet[address_of_cell];

   /* Get the value */
   var desired_value = desired_cell.v;
   console.log(desired_value);

   var entry = {species:"Rissa Tridactyla", matrix:"egg", individual:"K1"};

   var out = convertToCSV(entry);


fs.writeFile("./test", out, function(err) {
    if(err) {
        return console.log(err);
    }

    console.log("File created");
});
