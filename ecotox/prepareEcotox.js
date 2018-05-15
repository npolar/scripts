//js-xlsx
//Read MOSJ_data_HR.xlsx
   XLSX = require('xlsx');
   var fs = require('fs');
   //var filename = 'OC\ kylling\ blod\ 99.xls';
   var filename = 'MOSJ_data_HR.xlsx';


  /*write to csv file */
  function convertToCSV(objArray) {
       var obj = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
       var str = '';

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

   var workbook = XLSX.readFile("files/"+filename);

   var first_sheet_name = workbook.SheetNames[1];


   /* Get worksheet */
   var worksheet = workbook.Sheets[first_sheet_name];
   //console.log("worksheet",worksheet);

   /* Find desired cell */
   //Repeat each row/cell
//   for (var i=3;i<19;i++){
//   var address_of_cell = 'A'+i.toString();
//   var desired_cell = worksheet[address_of_cell];

   /* Get the value */
//   var desired_value = desired_cell.v;
//   console.log("desired cell:", address_of_cell, desired_value);
var str = 'project | laboratory | species | age | sex | matrix | sample_id | polar_bear_id | lab_ref | fat_percentage | wet_weight | date_sample_collected | date_report | latitude | longitude | placename | ownership | excel_uri | excel_filename | excel_type | excel_length | comment | first_name | last_name | analyte_category | analyte | corrected_blank_contamination | percent_recovery | detection_limit |  \r\n';
var out = str;

//Polar bear database
var db = XLSX.readFile("db/Isbjørndatabase\ april2018.xls");
var sheet = db.SheetNames[0];
var db_worksheet = db.Sheets[sheet];

for (var i=3;i<19;i++){

   //Find sample date
   var s_month = worksheet["H"+i.toString()].v == 'april' ? '04' :'08';
   var s_year = worksheet["C"+i.toString()].v;

   //Search for lat,lng, placename, id
   var unique_id = '';
   var placename = '';
   var latitude = '';
   var longitude = '';
   var our_id = parseInt(worksheet["B"+i.toString()].v);

   console.log("our_id",our_id);
   for (var j=3;j<2645;j++){

      if ((db_worksheet["D"+j.toString()]) != undefined) {
          console.log("sstring", j,db_worksheet["D"+j.toString()].v);
        if (our_id === parseInt(db_worksheet["D"+j.toString()].v)){
            unique_id = db_worksheet["A"+j.toString()].v;
            placename = db_worksheet["J"+j.toString()].v;
            latitude = db_worksheet["K"+j.toString()].v;
            longitude = db_worksheet["L"+j.toString()].v;
     }
  }
}

   var entry = {
     project:"",
     laboratory:"NMBU",
     species:"ursus maritimus",
     age: "",
     sex: worksheet["D"+i.toString()].v,
     matrix:'',
     sample_id: worksheet["B"+i.toString()].v,
     polar_bear_id: unique_id,
     lab_ref: worksheet["F"+i.toString()].v,
     fat_percentage:worksheet["H"+i.toString()].v,
     wet_weight:'',
     date_sample_collected: s_year + '-' + s_month,
     date_report:'',
     latitude:latitude,
     longitude:longitude,
     placename:placename,
     ownership:'NPI',
     excel_uri:'',
     excel_filename:'',
     excel_type:'',
     excel_length:'',
     collection:'ecotox',
     comment:'',
     first_name:'',
     last_name:'',
     organisation:''
   };


  // console.log(entry);
    out += convertToCSV(entry) + '\r\n';


 } //end for loop


fs.writeFile("ready/"+first_sheet_name+"_"+filename, out, function(err) {
    if(err) {
        return console.log(err);
    }

    console.log("File created");
});
