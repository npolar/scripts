//1) Upload file to archive - readExcel
//2. Create preliminary excel file - prepareEcotoc
//3. Read from manually prepared file back to database
//This is script no 3

//js-xlsx
XLSX = require('xlsx');
var fs = require('fs');
var request = require('request');
var XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest;

var uuid;



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
           str += line + '\r';
    //   }
       return str;
  }

  /*write to csv file */
  function checkExistence(val) {
    if (val != null) {
      return val.v
    } else {
      return "";
    }
  }

  //Filename - syntax with spaces: 'OC\ kylling\ blod\ 99.xls';
  var filename = 'Isbjorn\ blod\ 90-92_MOSJ_data_HR_sjekket050618.xlsx';
  var workbook = XLSX.readFile("done/"+filename);
  var sheet = workbook.SheetNames[0];
  var worksheet = workbook.Sheets[sheet];



for (var i=2;i<18;i++){

   var people = {
     first_name: worksheet["W"+i.toString()].v,
     last_name:worksheet["X"+i.toString()].v,
     organisation:worksheet["Y"+i.toString()].v
   };


var compound = {
   HCB:checkExistence(worksheet["AD"+i.toString()]),
   a_HCH:checkExistence(worksheet["AE"+i.toString()]),
   b_HCH:checkExistence(worksheet["AF"+i.toString()]),
   g_HCH:checkExistence(worksheet["AG"+i.toString()]),
   heptachlor:checkExistence(worksheet["AH"+i.toString()]),
   oxy_CHL:checkExistence(worksheet["AI"+i.toString()]),
   t_CHL:checkExistence(worksheet["AJ"+i.toString()]),
   c_CHL:checkExistence(worksheet["AK"+i.toString()]),
   tn_CHL:checkExistence(worksheet["AL"+i.toString()]),
   cn_CHL:checkExistence(worksheet["AM"+i.toString()]),
   op_DDE:checkExistence(worksheet["AN"+i.toString()]),
   pp_DDE:checkExistence(worksheet["AO"+i.toString()]),
   op_DDD:checkExistence(worksheet["AP"+i.toString()]),
   pp_DDD:checkExistence(worksheet["AQ"+i.toString()]),
   op_DDT:checkExistence(worksheet["AR"+i.toString()]),
   pp_DDT:checkExistence(worksheet["AS"+i.toString()]),
   mirex:checkExistence(worksheet["AT"+i.toString()]),
   aldrin:checkExistence(worksheet["AU"+i.toString()]),
   dieldrin:checkExistence(worksheet["AV"+i.toString()]),
   endrin:checkExistence(worksheet["AW"+i.toString()]),
   heptachlor_epoxide:checkExistence(worksheet["AX"+i.toString()]),
   CHB_26:checkExistence(worksheet["AY"+i.toString()]),
   CHB_40:checkExistence(worksheet["AZ"+i.toString()]),
   CHB_41:checkExistence(worksheet["BA"+i.toString()]),
   CHB_44:checkExistence(worksheet["BB"+i.toString()]),
   CHB_50:checkExistence(worksheet["BC"+i.toString()]),
   CHB_62:checkExistence(worksheet["BD"+i.toString()]),
   PCB_28:checkExistence(worksheet["BE"+i.toString()]),
   PCB_29:checkExistence(worksheet["BF"+i.toString()]),
   PCB_31:checkExistence(worksheet["BG"+i.toString()]),
   PCB_47:checkExistence(worksheet["BH"+i.toString()]),
   PCB_52:checkExistence(worksheet["BI"+i.toString()]),
   PCB_56:checkExistence(worksheet["BJ"+i.toString()]),
   PCB_66:checkExistence(worksheet["BK"+i.toString()]),
   PCB_74:checkExistence(worksheet["BL"+i.toString()]),
   PCB_87:checkExistence(worksheet["BM"+i.toString()]),
   PCB_99:checkExistence(worksheet["BN"+i.toString()]),
   PCB_101:checkExistence(worksheet["BO"+i.toString()]),
   PCB_105:checkExistence(worksheet["BP"+i.toString()]),
   PCB_110:checkExistence(worksheet["BQ"+i.toString()]),
   PCB_112:checkExistence(worksheet["BR"+i.toString()]),
   PCB_114:checkExistence(worksheet["BS"+i.toString()]),
   PCB_118:checkExistence(worksheet["BT"+i.toString()]),
   PCB_123:checkExistence(worksheet["BU"+i.toString()]),
   PCB_128:checkExistence(worksheet["BV"+i.toString()]),
   PCB_132:checkExistence(worksheet["BW"+i.toString()]),
   PCB_136:checkExistence(worksheet["BX"+i.toString()]),
   PCB_137:checkExistence(worksheet["BY"+i.toString()]),
   PCB_138:checkExistence(worksheet["BZ"+i.toString()]),
   PCB_141:checkExistence(worksheet["CA"+i.toString()]),
   PCB_149:checkExistence(worksheet["CB"+i.toString()]),
   PCB_151:checkExistence(worksheet["CC"+i.toString()]),
   PCB_153:checkExistence(worksheet["CD"+i.toString()]),
   PCB_156:checkExistence(worksheet["CE"+i.toString()]),
   PCB_157:checkExistence(worksheet["CF"+i.toString()]),
   PCB_167:checkExistence(worksheet["CG"+i.toString()]),
   PCB_170:checkExistence(worksheet["CH"+i.toString()]),
   PCB_180:checkExistence(worksheet["CI"+i.toString()]),
   PCB_183:checkExistence(worksheet["CJ"+i.toString()]),
   PCB_187:checkExistence(worksheet["CK"+i.toString()]),
   PCB_189:checkExistence(worksheet["CL"+i.toString()]),
   PCB_194:checkExistence(worksheet["CM"+i.toString()]),
   PCB_196:checkExistence(worksheet["CN"+i.toString()]),
   PCB_199:checkExistence(worksheet["CO"+i.toString()]),
   PCB_206:checkExistence(worksheet["CP"+i.toString()]),
   PCB_207:checkExistence(worksheet["CQ"+i.toString()]),
   PCB_209:checkExistence(worksheet["CR"+i.toString()]),
   BDE_28:checkExistence(worksheet["CS"+i.toString()]),
   BDE_47:checkExistence(worksheet["CT"+i.toString()]),
   BDE_77:checkExistence(worksheet["CU"+i.toString()]),
   BDE_99:checkExistence(worksheet["CV"+i.toString()]),
   BDE_100:checkExistence(worksheet["CW"+i.toString()]),
   BDE_153:checkExistence(worksheet["CX"+i.toString()]),
   BDE_154:checkExistence(worksheet["CY"+i.toString()]),
   BDE_183:checkExistence(worksheet["CZ"+i.toString()]),
   BDE_206:checkExistence(worksheet["DA"+i.toString()]),
   BDE_207:checkExistence(worksheet["DB"+i.toString()]),
   BDE_208:checkExistence(worksheet["DC"+i.toString()]),
   BDE_209:checkExistence(worksheet["DD"+i.toString()]),
   HBCDD:checkExistence(worksheet["DE"+i.toString()]),
   PCP:checkExistence(worksheet["DF"+i.toString()]),
   PBT:checkExistence(worksheet["DG"+i.toString()]),
   PBEB:checkExistence(worksheet["DH"+i.toString()]),
   DPTE:checkExistence(worksheet["DI"+i.toString()]),
   HBB:checkExistence(worksheet["DJ"+i.toString()]),
   Z4_OH_CB106:checkExistence(worksheet["DK"+i.toString()]),
   Z4_OH_CB107:checkExistence(worksheet["DL"+i.toString()]),
   Z4_OH_CB108:checkExistence(worksheet["DM"+i.toString()]),
   Z3_OH_CB118:checkExistence(worksheet["DN"+i.toString()]),
   Z4_OH_BDE42:checkExistence(worksheet["DO"+i.toString()]),
   Z3_OH_BDE47:checkExistence(worksheet["DP"+i.toString()]),
   Z6_OH_BDE47:checkExistence(worksheet["DQ"+i.toString()]),
   Z4_OH_BDE49:checkExistence(worksheet["DR"+i.toString()]),
   Z2_OH_BDE68:checkExistence(worksheet["DS"+i.toString()]),
   Z4_OH_CB106:checkExistence(worksheet["DT"+i.toString()]),
   Z4_OH_CB107:checkExistence(worksheet["DU"+i.toString()]),
   Z4_OH_CB130:checkExistence(worksheet["DV"+i.toString()]),
   Z3_OH_CB138:checkExistence(worksheet["DW"+i.toString()]),
   Z4_OH_CB146:checkExistence(worksheet["DX"+i.toString()]),
   Z4_OH_CB159:checkExistence(worksheet["DY"+i.toString()]),
   Z4_OH_CB172:checkExistence(worksheet["DZ"+i.toString()]),
   Z3_OH_CB180:checkExistence(worksheet["EA"+i.toString()]),
   Z4_OH_CB187:checkExistence(worksheet["EB"+i.toString()]),
   PFHxS:checkExistence(worksheet["EC"+i.toString()]),
   PFHxA:checkExistence(worksheet["ED"+i.toString()]),
   PFHpA:checkExistence(worksheet["EE"+i.toString()]),
   PFOA:checkExistence(worksheet["EF"+i.toString()]),
   PFNA:checkExistence(worksheet["EG"+i.toString()]),
   PFDA:checkExistence(worksheet["EH"+i.toString()]),
   PFUnDA:checkExistence(worksheet["EI"+i.toString()]),
   PFDoDA:checkExistence(worksheet["EJ"+i.toString()]),
   PFTrDA:checkExistence(worksheet["EK"+i.toString()]),
   PFTeDA:checkExistence(worksheet["EL"+i.toString()]),
   PFBS:checkExistence(worksheet["EM"+i.toString()]),
   PFHxS:checkExistence(worksheet["EN"+i.toString()]),
   PFOS:checkExistence(worksheet["EO"+i.toString()]),
   FOSA:checkExistence(worksheet["EP"+i.toString()]),
   N_MeFOSA:checkExistence(worksheet["EQ"+i.toString()]),
   N_MeFOSE:checkExistence(worksheet["ER"+i.toString()]),
   N_EtFOSA:checkExistence(worksheet["ES"+i.toString()]),
   N_EtFOSE:checkExistence(worksheet["ET"+i.toString()])
 }

 var analyte_category = {
   HCB:"organochlorine pesticides (OCPs)",
   a_HCH:"organochlorine pesticides (OCPs)",
   b_HCH:"organochlorine pesticides (OCPs)",
   g_HCH:"organochlorine pesticides (OCPs)",
   heptachlor:"organochlorine pesticides (OCPs)",
   oxy_CHL:"organochlorine pesticides (OCPs)",
   t_CHL:"organochlorine pesticides (OCPs)",
   c_CHL:"organochlorine pesticides (OCPs)",
   tn_CHL:"organochlorine pesticides (OCPs)",
   cn_CHL:"organochlorine pesticides (OCPs)",
   op_DDE:"organochlorine pesticides (OCPs)",
   pp_DDE:"organochlorine pesticides (OCPs)",
   op_DDD:"organochlorine pesticides (OCPs)",
   pp_DDD:"organochlorine pesticides (OCPs)",
   op_DDT:"organochlorine pesticides (OCPs)",
   pp_DDT:"organochlorine pesticides (OCPs)",
   mirex:"organochlorine pesticides (OCPs)",
   aldrin:"organochlorine pesticides (OCPs)",
   dieldrin:"organochlorine pesticides (OCPs)",
   endrin:"organochlorine pesticides (OCPs)",
   heptachlor_epoxide:"organochlorine pesticides (OCPs)",
   CHB_26:"organochlorine pesticides (OCPs)",
   CHB_40:"organochlorine pesticides (OCPs)",
   CHB_41:"organochlorine pesticides (OCPs)",
   CHB_44:"organochlorine pesticides (OCPs)",
   CHB_50:"organochlorine pesticides (OCPs)",
   CHB_62:"organochlorine pesticides (OCPs)",
   PCB_28:"polychlorinated biphenyls (PCBs)",
   PCB_29:"polychlorinated biphenyls (PCBs)",
   PCB_31:"polychlorinated biphenyls (PCBs)",
   PCB_47:"polychlorinated biphenyls (PCBs)",
   PCB_52:"polychlorinated biphenyls (PCBs)",
   PCB_56:"polychlorinated biphenyls (PCBs)",
   PCB_66:"polychlorinated biphenyls (PCBs)",
   PCB_74:"polychlorinated biphenyls (PCBs)",
   PCB_87:"polychlorinated biphenyls (PCBs)",
   PCB_99:"polychlorinated biphenyls (PCBs)",
   PCB_101:"polychlorinated biphenyls (PCBs)",
   PCB_105:"polychlorinated biphenyls (PCBs)",
   PCB_110:"polychlorinated biphenyls (PCBs)",
   PCB_112:"polychlorinated biphenyls (PCBs)",
   PCB_114:"polychlorinated biphenyls (PCBs)",
   PCB_118:"polychlorinated biphenyls (PCBs)",
   PCB_123:"polychlorinated biphenyls (PCBs)",
   PCB_128:"polychlorinated biphenyls (PCBs)",
   PCB_132:"polychlorinated biphenyls (PCBs)",
   PCB_136:"polychlorinated biphenyls (PCBs)",
   PCB_137:"polychlorinated biphenyls (PCBs)",
   PCB_138:"polychlorinated biphenyls (PCBs)",
   PCB_141:"polychlorinated biphenyls (PCBs)",
   PCB_149:"polychlorinated biphenyls (PCBs)",
   PCB_151:"polychlorinated biphenyls (PCBs)",
   PCB_153:"polychlorinated biphenyls (PCBs)",
   PCB_156:"polychlorinated biphenyls (PCBs)",
   PCB_157:"polychlorinated biphenyls (PCBs)",
   PCB_167:"polychlorinated biphenyls (PCBs)",
   PCB_170:"polychlorinated biphenyls (PCBs)",
   PCB_180:"polychlorinated biphenyls (PCBs)",
   PCB_183:"polychlorinated biphenyls (PCBs)",
   PCB_187:"polychlorinated biphenyls (PCBs)",
   PCB_189:"polychlorinated biphenyls (PCBs)",
   PCB_194:"polychlorinated biphenyls (PCBs)",
   PCB_196:"polychlorinated biphenyls (PCBs)",
   PCB_199:"polychlorinated biphenyls (PCBs)",
   PCB_206:"polychlorinated biphenyls (PCBs)",
   PCB_207:"polychlorinated biphenyls (PCBs)",
   PCB_209:"polychlorinated biphenyls (PCBs)",
   BDE_28:"brominated flame retardants (BFRs)",
   BDE_47:"brominated flame retardants (BFRs)",
   BDE_77:"brominated flame retardants (BFRs)",
   BDE_99:"brominated flame retardants (BFRs)",
   BDE_100:"brominated flame retardants (BFRs)",
   BDE_153:"brominated flame retardants (BFRs)",
   BDE_154:"brominated flame retardants (BFRs)",
   BDE_183:"brominated flame retardants (BFRs)",
   BDE_206:"brominated flame retardants (BFRs)",
   BDE_207:"brominated flame retardants (BFRs)",
   BDE_208:"brominated flame retardants (BFRs)",
   BDE_209:"brominated flame retardants (BFRs)",
   HBCDD:"brominated flame retardants (BFRs)",
   PCP:"polychlorinated biphenyls (PCBs)",
   PBT:"brominated flame retardants (BFRs)",
   PBEB:"brominated flame retardants (BFRs)",
   DPTE:"brominated flame retardants (BFRs)",
   HBB:"brominated flame retardants (BFRs)",
   Z4_OH_CB106:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z4_OH_CB107:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z4_OH_CB108:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z3_OH_CB118:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z4_OH_BDE42:"hydroxyl polybrominated diphenyl ethers (OH-PBDEs)",
   Z3_OH_BDE47:"hydroxyl polybrominated diphenyl ethers (OH-PBDEs)",
   Z6_OH_BDE47:"hydroxyl polybrominated diphenyl ethers (OH-PBDEs)",
   Z4_OH_BDE49:"hydroxyl polybrominated diphenyl ethers (OH-PBDEs)",
   Z2_OH_BDE68:"hydroxyl polybrominated diphenyl ethers (OH-PBDEs)",
   Z4_OH_CB106:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z4_OH_CB107:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z4_OH_CB130:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z3_OH_CB138:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z4_OH_CB146:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z4_OH_CB159:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z4_OH_CB172:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z3_OH_CB180:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   Z4_OH_CB187:"hydroxyl polychlorinated biphenyls (OH-PCBs)",
   PFHxS:"poly- and perfluoroalkyl subtances (PFAS)",
   PFHxA:"poly- and perfluoroalkyl subtances (PFAS)",
   PFHpA:"poly- and perfluoroalkyl subtances (PFAS)",
   PFOA:"poly- and perfluoroalkyl subtances (PFAS)",
   PFNA:"poly- and perfluoroalkyl subtances (PFAS)",
   PFDA:"poly- and perfluoroalkyl subtances (PFAS)",
   PFUnDA:"poly- and perfluoroalkyl subtances (PFAS)",
   PFDoDA:"poly- and perfluoroalkyl subtances (PFAS)",
   PFTrDA:"poly- and perfluoroalkyl subtances (PFAS)",
   PFTeDA:"poly- and perfluoroalkyl subtances (PFAS)",
   PFBS:"poly- and perfluoroalkyl subtances (PFAS)",
   PFHxS:"poly- and perfluoroalkyl subtances (PFAS)",
   PFOS:"poly- and perfluoroalkyl subtances (PFAS)",
   FOSA:"poly- and perfluoroalkyl subtances (PFAS)",
   N_MeFOSA:"poly- and perfluoroalkyl subtances (PFAS)",
   N_MeFOSE:"poly- and perfluoroalkyl subtances (PFAS)",
   N_EtFOSA:"poly- and perfluoroalkyl subtances (PFAS)",
   N_EtFOSE:"poly- and perfluoroalkyl subtances (PFAS)"
 }



   var compound_arr = [];

   for (var k in compound) {
     var compound_entry = {
         analyte_category: analyte_category[k],
         analyte:k,
         wet_weight:compound[k],
         corrected_blank_contamination: checkExistence(worksheet["Z"+i.toString()]),
         percent_recovery: checkExistence(worksheet["AA"+i.toString()]),
         unit: checkExistence(worksheet["AB"+i.toString()]),
         detection_limit:checkExistence(worksheet["AC"+i.toString()])
     };

      //Push to array if compound has a value i.e. is not an empty string
      if (compound[k].toString() !== ''){
           compound_arr.push(compound_entry);
      };

  };

   var entry = {
     schema:  "http://api.npolar.no/schema/ecotox",
     lang:"en",
     project: checkExistence(worksheet["A"+i.toString()]),
     laboratory: checkExistence(worksheet["B"+i.toString()]),
     species: checkExistence(worksheet["C"+i.toString()]),
     age: checkExistence(worksheet["D"+i.toString()]),
     sex: checkExistence(worksheet["E"+i.toString()]),
     age_group: checkExistence(worksheet["F"+i.toString()]),
     matrix: checkExistence(worksheet["G"+i.toString()]),
     sample_id: checkExistence(worksheet["H"+i.toString()]),
     NPI_sample_id: checkExistence(worksheet["I"+i.toString()]),
     lab_id: checkExistence(worksheet["J"+i.toString()]),
     fat_percentage: parseFloat(checkExistence(worksheet["K"+i.toString()])),
     date_sample_collected:checkExistence(worksheet["L"+i.toString()]),
     date_report:checkExistence(worksheet["M"+i.toString()]),
     latitude: parseFloat(checkExistence(worksheet["N"+i.toString()])),
     longitude:parseFloat(checkExistence(worksheet["O"+i.toString()])),
     placename:checkExistence(worksheet["P"+i.toString()]),
     ownership:checkExistence(worksheet["Q"+i.toString()]),
     excel_uri:checkExistence(worksheet["R"+i.toString()]),
     excel_filename:checkExistence(worksheet["S"+i.toString()]),
     excel_type: checkExistence(worksheet["T"+i.toString()]),
     excel_length: checkExistence(worksheet["U"+i.toString()]),
     comment: checkExistence(worksheet["V"+i.toString()]),
     collection:"ecotox",
     compound: compound_arr,
     people: people,
     created: new Date().toISOString(),
     updated: new Date().toISOString(),
     created_by:"siri.uldal@npolar.no",
     updated_by:"siri.uldal@npolar.no",
     id:uuid,
     _id:uuid
   };


   console.log(entry);

   //Decided to go for synchronous because if if fails, the script should terminate since I have no uuid
   var xhr = new XMLHttpRequest();
   xhr.open("GET", "http://db-test.data.npolar.no:5984/_uuids",false);
   xhr.send(null);

   if (xhr.status === 200) {
      var ret = JSON.parse(xhr.responseText);
      uuid = ret['uuids'][0];
      console.log("uuid",uuid);


   //Push to database
    var url = 'http://db-test.data.npolar.no:5984/ecotox/'+uuid;
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
  }; //end uuid

 } //end for loop
