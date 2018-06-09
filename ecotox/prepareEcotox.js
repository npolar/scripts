//1) Upload file to archive - readExcel
//2. Create preliminary excel file - prepareEcotoc
//3. Read from manually prepared file back to database

//js-xlsx
XLSX = require('xlsx');
var fs = require('fs');

  /*write to csv file */
  function convertToCSV(objArray) {
       var obj = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
       var str = '';

    //   for (var i = 0; i < Object.keys(obj).length; i++) {
           var line = '';
           for (var key in obj){
             var attrName = key;
             var attrValue = obj[key];
              //console.log(attrName, attrValue);
              line += attrValue + "|";
           }
           str = line + '\r';
    //   }
       return str;
  }

  /*write to csv file */
  function checkExistence(val) {
    if ((val != null) && (typeof val != undefined)) {
      return val.v
    } else {
      return "";
    }
  }

  //Filename - syntax with spaces: 'OC\ kylling\ blod\ 99.xls';
  //var filename = 'MOSJ_data_HR.xlsx';
  var filename = 'plasma 90-98 Espen Henriksen PCBs2.xls';
  var workbook = XLSX.readFile("files/"+filename);
  var sheet = workbook.SheetNames[0];
  var worksheet = workbook.Sheets[sheet];


var str = 'project | laboratory | species | age | sex | age_group | matrix | sample_id | NPI_sample_id | lab_id |' +
'fat_percentage | date_sample_collected | date_report | latitude | longitude | placename |' +
'ownership | excel_uri | excel_filename | excel_type | excel_length | comment | first_name | last_name |' +
'organisation | corrected_blank_contamination | '+
'percent_recovery | unit | detection_limit | HCB | a-HCH |b-HCH | g-HCH | heptachlor | oxy-CHL |' +
't-CHL | c-CHL | tn-CHL | cn-CHL | op-DDE | pp-DDE | op-DDD | pp-DDD | op-DDT | pp-DDT | mirex |'+
'aldrin | dieldrin | endrin | heptachlor epoxide | CHB-26 | CHB-40 | CHB-41 | CHB-44 | CHB-50 | CHB-62 |'+
'PCB-28 | PCB-29 | PCB-31 | PCB-47 | PCB-52 | PCB-56 | PCB-66 | PCB-74 | PCB-87 | PCB-99 |' +
'PCB-101 | PCB-105 | PCB-110 | PCB-112 | PCB-114 | PCB-118 | PCB-123 | PCB-128 | PCB-132 | PCB-136 | PCB-137 |' +
'PCB-138 | PCB-141 | PCB-149 | PCB-151 | PCB-153 | PCB-156 | PCB-157 | PCB-167 | PCB-170 | PCB-180 | PCB-183 |' +
'PCB-187 | PCB-189 | PCB-194 | PCB-196 | PCB-199 | PCB-206 | PCB-207 | PCB-209 |'+
'BDE-28 | BDE-47 | BDE-77 | BDE-99 | BDE-100 | BDE-153 | BDE-154 | BDE-183 | BDE-206 | BDE-207 |BDE-208 |' +
'BDE-209 | HBCDD | PCP | PBT | PBEB | DPTE | HBB | 4-OH-CB106 | 4-OH-CB107 | 4-OH-CB108 | 3-OH-CB118 | 4-OH-BDE42 | 3-OH-BDE47 |'+
'6-OH-BDE47 | 4-OH-BDE49 | 2-OH-BDE68 | 4-OH-CB106 | 4-OH-CB107 | 4-OH-CB130 | 3-OH-CB138 | 4-OH-CB146 |'+
'4-OH-CB159 | 4-OH-CB172 | 3-OH-CB180 | 4-OH-CB187 | PFHxS | PFHxA | PFHpA | PFOA | PFNA | PFDA | PFUnDA |' +
'PFDoDA | PFTrDA | PFTeDA | PFBS | PFHxS | PFOS | FOSA | N-MeFOSA | N-MeFOSE | N-EtFOSA | N-EtFOSE \r\n';

var out = str;

//Polar bear database - to be compared with for polar bear data
var db = XLSX.readFile("db/Isbjørndatabase\ april2018.xls");
var db_sheet = db.SheetNames[0];
var db_worksheet = db.Sheets[db_sheet];

for (var i=2;i<25;i++){

   //Find sample date
//   var s_month;
//   if ((worksheet["E"+i.toString()].v).toString() === 'april'){
//      s_month = '04'
//   } else {
//     s_month = '08'
//   }
/*   var s_year = worksheet["C"+i.toString()].v;

   //Search for lat,lng, placename, id
   var unique_id = '';
   var placename = '';
   var latitude = '';
   var longitude = '';
   var sample_id = parseInt(worksheet["B"+i.toString()].v);

   for (var j=3;j<2645;j++){

      if ((db_worksheet["D"+j.toString()]) != undefined) {
        //  console.log("sstring", j,db_worksheet["D"+j.toString()].v);
        if (sample_id === parseInt(db_worksheet["D"+j.toString()].v)){
            unique_id = db_worksheet["A"+j.toString()].v;
            placename = db_worksheet["J"+j.toString()].v;
            latitude = db_worksheet["K"+j.toString()].v;
            longitude = db_worksheet["L"+j.toString()].v;
     }
  }
} */



   var entry = {
     project:"MOSJ",
     laboratory:"NMBU",
     species:"ursus maritimus",
     age: worksheet["C"+i.toString()].v,
     sex: worksheet["D"+i.toString()].v,
     age_group: "",
     matrix:'plasma',
     sample_id: worksheet["A"+i.toString()].v,
     NPI_sample_id: ((worksheet["A"+i.toString()].v).toString()).substring(0,4),
     lab_id: '',
     fat_percentage: parseFloat(worksheet["H"+i.toString()].v),
     date_sample_collected: worksheet["G"+i.toString()].v,     //s_year + '-' + s_month,
     date_report:'',
     latitude: '',
     longitude:'',
     placename:'',
     ownership:'NPI',
     excel_uri:'',
     excel_filename:'',
     excel_type:'',
     excel_length:'',
     comment:'Available family: ' + (checkExistence(worksheet["E"+i.toString()])) + 'Reprod status: ' + (worksheet["F"+i.toString()].v).toString(),
     first_name:'Espen',
     last_name:'Henriksen',
     organisation:'NPI',
     corrected_blank_contamination:'unknown',
     percent_recovery:'',
     unit:'ng/g',
     detection_limit:'',
     HCB:'',
     a_HCH:'',
     b_HCH:'',
     g_HCH:'',
     heptachlor:'',
     oxy_CHL:'',
     t_CHL:'',
     c_CHL:'',
     tn_CHL:'',
     cn_CHL:'',
     op_DDE:'',
     pp_DDE:'',
     op_DDD:'',
     pp_DDD:'',
     op_DDT:'',
     pp_DDT:'',
     mirex:'',
     aldrin:'',
     dieldrin:'',
     endrin:'',
     heptachlor_epoxide: '',
     CHB_26:'',
     CHB_40:'',
     CHB_41:'',
     CHB_44:'',
     CHB_50:'',
     CHB_62:'',
     PCB_28:'',
     PCB_29:'',
     PCB_31:'',
     PCB_47:'',
     PCB_52:'',
     PCB_56:'',
     PCB_66:'',
     PCB_74:'',
     PCB_87:'',
     PCB_99:worksheet["O"+i.toString()].v,
     PCB_101:'',
     PCB_105:'',
     PCB_110:'',
     PCB_112:'',
     PCB_114:'',
     PCB_118:worksheet["P"+i.toString()].v,
     PCB_123:'',
     PCB_128:'',
     PCB_132:'',
     PCB_136:'',
     PCB_137:'',
     PCB_138:'',
     PCB_141:'',
     PCB_149:'',
     PCB_151:'',
     PCB_153:worksheet["Q"+i.toString()].v,
     PCB_156:worksheet["R"+i.toString()].v,
     PCB_157:'',
     PCB_167:'',
     PCB_170:'',
     PCB_180:worksheet["S"+i.toString()].v,
     PCB_183:'',
     PCB_187:'',
     PCB_189:'',
     PCB_194:worksheet["T"+i.toString()].v,
     PCB_196:'',
     PCB_199:'',
     PCB_206:'',
     PCB_207:'',
     PCB_209:'',
     BDE_28:'',
     BDE_47:'',
     BDE_77:'',
     BDE_99:'',
     BDE_100:'',
     BDE_153:'',
     BDE_154:'',
     BDE_183:'',
     BDE_206:'',
     BDE_207:'',
     BDE_208:'',
     BDE_209:'',
     HBCDD:'',
     PBT:'',
     PBEB:'',
     DPTE:'',
     HBB:'',
     PCP:'',
     Z4_OH_CB106:'',
     Z4_OH_CB107:'',
     Z4_OH_CB108:'',
     Z3_OH_CB118:'',
     Z4_OH_BDE42:'',
     Z3_OH_BDE47:'',
     Z6_OH_BDE47:'',
     Z4_OH_BDE49:'',
     Z2_OH_BDE68:'',
     Z4_OH_CB106:'',
     Z4_OH_CB107:'',
     Z4_OH_CB130:'',
     Z3_OH_CB138:'',
     Z4_OH_CB146:'',
     Z4_OH_CB159:'',
     Z4_OH_CB172:'',
     Z3_OH_CB180:'',
     Z4_OH_CB187:'',
     PFHxS:'',
     PFHxA:'',
     PFHpA:'',
     PFOA:'',
     PFNA:'',
     PFDA:'',
     PFUnDA:'',
     PFDoDA:'',
     PFTrDA:'',
     PFTeDA:'',
     PFBS:'',
     PFHxS:'',
     PFOS:'',
     FOSA:'',
     N_MeFOSA:'',
     N_MeFOSE:'',
     N_EtFOSA:'',
     N_EtFOSE:''
   };

   // console.log(entry);
     out += convertToCSV(entry) + '\r\n';

}; //for

var filename2 = filename.substr(0,(filename.length-5));
fs.writeFile("ready/"+sheet+"_"+filename2+".txt", out, function(err) {
     console.log("File created");
    if(err) {
        return console.log(err);
    }


});
