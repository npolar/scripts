#Create analyte input
createInput <- function(file,row,det_start,rec_start,col_start,col_end){
     
   #Extract from Excel sheet
   analyte= sapply(file, "[", c(row))[col_start:col_end]

   #Convert to character, otherwise script will slow down
   s = substr(x = analyte, start = 1, stop = 20)

   #Extract detection limit and percent recovery from excel sheet
   det_lim = c(file[[det_start]][row])
   prc_rec = c(file[[rec_start]][row])

   #if det_lim or prc_rec is NA, remove it to correspond with js script
   if (is.na(det_lim)){
     det_lim = ""
   }

   if (is.na(prc_rec)){
     prc_rec = ""
   }
   
  return(paste0(s,"*", det_lim,"*",prc_rec))
}

#create transformation Excel sheet
createExcel <- function(){

  #Using XLConnect and readxl to interact with Excel
  #Readxl reads old and excel files (XLS and XLSX), while XLConnect writes to file
  library(XLConnect)
  library(readxl)

  #Start and end coloumn for reading
  excelfile <- "R08-97_Gronlandssel.XLS"
  excelsheet <- "RAPPMAL"
  excelfilechop <- read.table(text = excelfile, sep = ".", as.is = TRUE)
  outExcelfile <- paste0(excelsheet,"_",excelfilechop$V1,".xlsx")

  #Set input parameters
  project <- ""
  laboratory <- "NMBU"
  species <- "phoca groenlandica"
  matrix <- "blubber"
  date_sample_collected <- "før 07.1995"
  date_report <- "03.97"
  latitude <- ""
  longitude <- ""
  placename <- "Svalbard"
  unit <-"ng/g"
  ownership <- "NPI"
  excel_uri <- "dbbaa373-69e6-c700-9614-cef0f522635a"
  excel_filename <- "R08-97_Gronlandssel.XLS"
  excel_type <-"application/vnd.ms-excel"
  excel_length <-"94720" 
  comment <- paste("Kontrollprøven oppnådde verdien: 4949.",
       "Akseptabel verdi er fra 4503 til 7099. Oppdragsgiver:Lars Kleivane,",
       "Veterinærinstituttet.Torbjørn Severinsen, Norsk Polarinstitutt.")
  first_name <- "Heli"
  last_name <- "Routti"
  organisation <- "NPI"

  col_start <- 4  #Start to read ids from col..
  col_end   <- 13 #to col
  det_start <- 2  #Col for detection limit
  rec_start <- 3  #Col for precent recovery 
  numb <- 10      #Number of empty rows needed
 
  #Read from Excel
  file <- read_excel(excelfile, sheet = excelsheet)

 
  project =  		rep(c(project),each=numb,stringsAsFactors = FALSE) 
  laboratory = 		rep(c(laboratory),each=numb)
  species =  		rep(c(species),each=numb)
  age = 		rep('',each=numb,stringsAsFactors = FALSE)  
  sex = 		rep('',each=numb,stringsAsFactors = FALSE)
  age_group = 		rep('',each=numb,stringsAsFactors = FALSE) 
  matrix = 		rep(c(matrix),each=numb)
  sample_id = 		paste0("97.03.-", substr(x = sapply(file, "[", c(29))[col_start:col_end], start = 1, stop = 20))    
  NPI_sample_id = 	paste0("97.03.-", substr(x = sapply(file, "[", c(29))[col_start:col_end], start = 1, stop = 20))
  lab_id= 		sapply(file, "[", c(28))[col_start:col_end]  
  fat_percentage= 	sapply(file, "[", c(31))[col_start:col_end]    
  date_sample_collected= rep(c(date_sample_collected),each=numb) 
  date_report= 		rep(c(date_report),each=numb) 
  latitude= 		rep(c(latitude),each=numb)  
  longitude= 		rep(c(longitude),each=numb) 
  placename= 		rep(c(placename),each=numb)
  ownership= 		rep(c(ownership),each=numb)  
  excel_uri= 		rep(c(excel_uri),each=numb)
  excel_filename= 	rep(c(excel_filename),each=numb)
  excel_type= 		rep(c(excel_type),each=numb)
  excel_length= 	rep(c(excel_length),each=numb)
  comment = 		rep(c(comment),each=numb)
  first_name= 		rep(c(first_name),each=numb)
  last_name= 		rep(c(last_name),each=numb)
  organisation= 	rep(c(organisation),each=numb)
  corrected_blank_contamination= rep('',each=numb,stringsAsFactors = FALSE)
  percent_recovery= 	rep('',each=numb,stringsAsFactors = FALSE)
  unit= 		rep(c(unit),each=numb)
  detection_limit= 	rep('',each=numb,stringsAsFactors = FALSE)
  HCB= 			createInput(file,38,det_start,rec_start,col_start,col_end) 
  a_HCH= 		createInput(file,40,det_start,rec_start,col_start,col_end)  
  b_HCH= 		createInput(file,41,det_start,rec_start,col_start,col_end)
  g_HCH= 		createInput(file,42,det_start,rec_start,col_start,col_end)
  heptachlor= 		rep('',each=numb,stringsAsFactors = FALSE)
  oxy_CHL= 		createInput(file,45,det_start,rec_start,col_start,col_end) 
  t_CHL= 		createInput(file,46,det_start,rec_start,col_start,col_end)
  c_CHL= 		createInput(file,47,det_start,rec_start,col_start,col_end)
  tn_CHL= 		createInput(file,48,det_start,rec_start,col_start,col_end)
  cn_CHL= 		rep('',each=numb,stringsAsFactors = FALSE)
  op_DDE= 		rep('',each=numb,stringsAsFactors = FALSE)
  pp_DDE= 		createInput(file,51,det_start,rec_start,col_start,col_end)
  op_DDD= 		createInput(file,52,det_start,rec_start,col_start,col_end)
  pp_DDD= 		createInput(file,53,det_start,rec_start,col_start,col_end)
  op_DDT= 		rep('',each=numb,stringsAsFactors = FALSE)
  pp_DDT= 		createInput(file,54,det_start,rec_start,col_start,col_end)
  mirex= 		rep('',each=numb,stringsAsFactors = FALSE)
  aldrin= 		rep('',each=numb,stringsAsFactors = FALSE)
  dieldrin= 		rep('',each=numb,stringsAsFactors = FALSE)
  endrin= 		rep('',each=numb,stringsAsFactors = FALSE)
  heptachlor_epoxide= 	rep('',each=numb,stringsAsFactors = FALSE)
  CHB_26 = 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_40= 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_41= 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_44= 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_50= 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_62= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_28= 		createInput(file,58,det_start,rec_start,col_start,col_end)
  PCB_29= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_31= 		createInput(file,57,det_start,rec_start,col_start,col_end)
  PCB_47= 		createInput(file,60,det_start,rec_start,col_start,col_end)
  PCB_52= 		createInput(file,59,det_start,rec_start,col_start,col_end)
  PCB_56= 		createInput(file,63,det_start,rec_start,col_start,col_end)
  PCB_66= 		createInput(file,62,det_start,rec_start,col_start,col_end)
  PCB_74= 		createInput(file,61,det_start,rec_start,col_start,col_end)
  PCB_87= 		createInput(file,66,det_start,rec_start,col_start,col_end)
  PCB_99= 		createInput(file,65,det_start,rec_start,col_start,col_end)
  PCB_101= 		createInput(file,64,det_start,rec_start,col_start,col_end)
  PCB_105= 		createInput(file,74,det_start,rec_start,col_start,col_end)
  PCB_110= 		createInput(file,68,det_start,rec_start,col_start,col_end)
  PCB_112= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_114= 		createInput(file,72,det_start,rec_start,col_start,col_end)
  PCB_118= 		createInput(file,71,det_start,rec_start,col_start,col_end)
  PCB_123= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_128= 		createInput(file,80,det_start,rec_start,col_start,col_end)
  PCB_132= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_136= 		createInput(file,67,det_start,rec_start,col_start,col_end)
  PCB_137= 		createInput(file,76,det_start,rec_start,col_start,col_end)
  PCB_138= 		createInput(file,77,det_start,rec_start,col_start,col_end)
  PCB_141= 		createInput(file,75,det_start,rec_start,col_start,col_end)
  PCB_149= 		createInput(file,70,det_start,rec_start,col_start,col_end)
  PCB_151= 		createInput(file,69,det_start,rec_start,col_start,col_end)
  PCB_153= 		createInput(file,73,det_start,rec_start,col_start,col_end)
  PCB_156= 		createInput(file,81,det_start,rec_start,col_start,col_end)
  PCB_157= 		createInput(file,82,det_start,rec_start,col_start,col_end)
  PCB_167= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_170= 		createInput(file,84,det_start,rec_start,col_start,col_end)
  PCB_180= 		createInput(file,83,det_start,rec_start,col_start,col_end)
  PCB_183= 		createInput(file,79,det_start,rec_start,col_start,col_end)
  PCB_187= 		createInput(file,78,det_start,rec_start,col_start,col_end)
  PCB_189= 		createInput(file,87,det_start,rec_start,col_start,col_end)
  PCB_194= 		createInput(file,88,det_start,rec_start,col_start,col_end)
  PCB_196= 		createInput(file,86,det_start,rec_start,col_start,col_end)
  PCB_199= 		createInput(file,85,det_start,rec_start,col_start,col_end)
  PCB_206= 		createInput(file,89,det_start,rec_start,col_start,col_end)
  PCB_207= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_209= 		createInput(file,90,det_start,rec_start,col_start,col_end)
  BDE_28= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_47= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_77= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_99= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_100= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_153= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_154= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_183= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_206= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_207= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_208= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_209= 		rep('',each=numb,stringsAsFactors = FALSE)
  HBCDD= 		rep('',each=numb,stringsAsFactors = FALSE)
  PBT= 			rep('',each=numb,stringsAsFactors = FALSE)
  PBEB= 		rep('',each=numb,stringsAsFactors = FALSE)
  DPTE= 		rep('',each=numb,stringsAsFactors = FALSE)
  HBB= 			rep('',each=numb,stringsAsFactors = FALSE)
  PCP= 			rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB106= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB107= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB108= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_CB118= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_BDE42= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_BDE47= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z6_OH_BDE47= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_BDE49= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z2_OH_BDE68= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB130= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_CB138= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB146= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB159= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB172= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_CB180= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB187= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFHxA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFHpA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFOA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFNA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFDA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFUnDA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFDoDA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFTrDA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFTeDA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFBS= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFHxS= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFOS= 		rep('',each=numb,stringsAsFactors = FALSE)
  FOSA= 		rep('',each=numb,stringsAsFactors = FALSE)
  N_MeFOSA= 		rep('',each=numb,stringsAsFactors = FALSE)
  N_MeFOSE= 		rep('',each=numb,stringsAsFactors = FALSE)
  N_EtFOSA= 		rep('',each=numb,stringsAsFactors = FALSE)
  N_EtFOSE= 		rep('',each=numb,stringsAsFactors = FALSE)
  reference= 		rep('',each=numb,stringsAsFactors = FALSE)
  brPFOS= 		rep('',each=numb,stringsAsFactors = FALSE)
  linPFOS= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFOSbr2= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFOSlin2= 		rep('',each=numb,stringsAsFactors = FALSE)
  FTSA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFHpS= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFPeA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFPeDA= 		rep('',each=numb,stringsAsFactors = FALSE)
  PECB= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFNS= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFDS= 		rep('',each=numb,stringsAsFactors = FALSE)
  PFBA= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z1_3_DCB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z1_4_DCB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z1_2_DCB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z1_3_5_TCB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z1_2_4_TCB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z1_2_3_TCB= 		rep('',each=numb,stringsAsFactors = FALSE)
  hexachlorobutadiene= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z1_2_3_4_TTCB= 	rep('',each=numb,stringsAsFactors = FALSE)
  pentachloroanisole= 	rep('',each=numb,stringsAsFactors = FALSE)
  octachlorostyrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  a_endosulfan= 	rep('',each=numb,stringsAsFactors = FALSE)
  b_endosulfan= 	rep('',each=numb,stringsAsFactors = FALSE)
  methoxychlor= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_2_FTS= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z6_2_FTS= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z8_2_FTS= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z8_2_FTCA= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z8_2_FTUCA= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z10_2_FTCA= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z10_2_FTUCA= 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_32= 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_38= 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_58= 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_69= 		rep('',each=numb,stringsAsFactors = FALSE)
  BCP= 			rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_DDE= 	rep('',each=numb,stringsAsFactors = FALSE)
  CDT= 			rep('',each=numb,stringsAsFactors = FALSE)
  DDE_PCB_87= 		rep('',each=numb,stringsAsFactors = FALSE)
  OCS= 			rep('',each=numb,stringsAsFactors = FALSE)
  photomirex= 		rep('',each=numb,stringsAsFactors = FALSE)
  HCBD= 		rep('',each=numb,stringsAsFactors = FALSE)
  ChCl= 		rep('',each=numb,stringsAsFactors = FALSE)
  MC6= 			rep('',each=numb,stringsAsFactors = FALSE)
  B6_923a= 		rep('',each=numb,stringsAsFactors = FALSE)
  B7_499= 		rep('',each=numb,stringsAsFactors = FALSE)
  B7_515= 		rep('',each=numb,stringsAsFactors = FALSE)
  B7_1474_B7_1440= 	rep('',each=numb,stringsAsFactors = FALSE)
  B7_1001= 		rep('',each=numb,stringsAsFactors = FALSE)
  B7_1059a= 		rep('',each=numb,stringsAsFactors = FALSE)
  B7_1450= 		rep('',each=numb,stringsAsFactors = FALSE)
  B8_531= 		rep('',each=numb,stringsAsFactors = FALSE)
  B8_789= 		rep('',each=numb,stringsAsFactors = FALSE)
  B8_806= 		rep('',each=numb,stringsAsFactors = FALSE)
  B8_810= 		rep('',each=numb,stringsAsFactors = FALSE)
  B8_1412= 		rep('',each=numb,stringsAsFactors = FALSE)
  B8_1413= 		rep('',each=numb,stringsAsFactors = FALSE)
  B8_1414= 		rep('',each=numb,stringsAsFactors = FALSE)
  B8_1471= 		rep('',each=numb,stringsAsFactors = FALSE)
  B8_2229= 		rep('',each=numb,stringsAsFactors = FALSE)
  B9_715= 		rep('',each=numb,stringsAsFactors = FALSE)
  B9_718= 		rep('',each=numb,stringsAsFactors = FALSE)
  B9_743_B9_2006= 	rep('',each=numb,stringsAsFactors = FALSE)
  B9_1025= 		rep('',each=numb,stringsAsFactors = FALSE)
  B9_1046= 		rep('',each=numb,stringsAsFactors = FALSE)
  B9_1679= 		rep('',each=numb,stringsAsFactors = FALSE)
  B10_1110= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_1= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_3= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_4_10= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_6= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_7_9= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_8_5= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_12_13= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_15_17= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_16_32= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_18= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_19= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_20= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_22= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_24_27= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_25= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_26= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_28_31= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_31_28= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_33= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_33_20= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_37= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_38= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_40= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_42= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_43= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_44= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_45= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_46= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_48= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_49= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_47_48= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_47_49= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_50= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_51= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_53= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_54_29= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_55= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_56_60= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_59= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_60= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_63= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_64= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_64_41= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_66_95= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_70= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_70_74= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_70_76= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_70_76_98= 	rep('',each=numb,stringsAsFactors = FALSE)
  PCB_71_41_64= 	rep('',each=numb,stringsAsFactors = FALSE)
  PCB_76= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_77= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_81= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_81_87= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_82= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_83= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_84= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_85= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_91= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_92= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_95= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_97= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_99_113= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_100= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_101_90= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_107= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_113= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_114_122= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_119= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_122= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_126= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_129= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_129_178= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_130= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_133= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_134_131= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_135_144= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_138_164= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_146= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_147= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_157_201= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_158= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_163_138= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_169= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_170_190= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_171= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_171_202= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_171_202_156= 	rep('',each=numb,stringsAsFactors = FALSE)
  PCB_172= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_172_192= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_173= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_174= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_175= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_176= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_177= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_178= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_179= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_180_193= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_182_187= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_185= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_191= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_193= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_195= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_196_203= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_197= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_198= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_200= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_201= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_201_204= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_202= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_202_171= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_203= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_203_196= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_204= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_205= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_208= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_208_195= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_138_163= 		rep('',each=numb,stringsAsFactors = FALSE)
  PCB_153_132= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB79= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_CB85= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB97= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB104= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB107_4_OH_CB108= rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB112= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z2_OH_CB114= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB120= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB127= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB134= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_CB153= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB162= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB163= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB165= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB177= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB178= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_CB182= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_CB183= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_CB184= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB193= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB198= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB199= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB200= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB201= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB202= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z44_diOH_CB202= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_OH_CB203= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_CB208= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z10_OH_CB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB49= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB49= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB52= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB52= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB64= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB70= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB70= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB87= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB87= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB91= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB91= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB101= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB101= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB110= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB110= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB149= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB149= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB132= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB132= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB141= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB141= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeSO2_CB174= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeSO2_CB174= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z19_MeSO2_CB= 	rep('',each=numb,stringsAsFactors = FALSE)
  BDE_17= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_25= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_49= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_54= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_66= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_71= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_71_49= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_75= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_85= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_116= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_119= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_126= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_138= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_139= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_140= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_155= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_100_5_MeO_BDE47= 	rep('',each=numb,stringsAsFactors = FALSE)
  BDE_154_BB153= 	rep('',each=numb,stringsAsFactors = FALSE)
  BDE_156= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_171= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_180= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_181= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_184= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_190= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_191= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_196= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_197= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_201= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_202= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_203= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_205= 		rep('',each=numb,stringsAsFactors = FALSE)
  BDE_208_207= 		rep('',each=numb,stringsAsFactors = FALSE)
  a_HBCD= 		rep('',each=numb,stringsAsFactors = FALSE)
  b_HBCD= 		rep('',each=numb,stringsAsFactors = FALSE)
  g_HBCD= 		rep('',each=numb,stringsAsFactors = FALSE)
  TBPA= 		rep('',each=numb,stringsAsFactors = FALSE)
  BTBPE= 		rep('',each=numb,stringsAsFactors = FALSE)
  TBB= 			rep('',each=numb,stringsAsFactors = FALSE)
  TBBPA_DBPE= 		rep('',each=numb,stringsAsFactors = FALSE)
  DPDPE= 		rep('',each=numb,stringsAsFactors = FALSE)
  ATE= 			rep('',each=numb,stringsAsFactors = FALSE)
  BEHTBP= 		rep('',each=numb,stringsAsFactors = FALSE)
  TBP= 			rep('',each=numb,stringsAsFactors = FALSE)
  BTBPI= 		rep('',each=numb,stringsAsFactors = FALSE)
  TBBPA_DAE= 		rep('',each=numb,stringsAsFactors = FALSE)
  EHTBB= 		rep('',each=numb,stringsAsFactors = FALSE)
  DBDPE= 		rep('',each=numb,stringsAsFactors = FALSE)
  TBA= 			rep('',each=numb,stringsAsFactors = FALSE)
  TBBPA= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_HpCS= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z44_DiBB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z2255_TetBB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z224455_HexBB= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z6_MeO_BDE17= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeO_BDE17= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z2_MeO_BDE28= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeO_BDE42= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z6_MeO_BDE47= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z3_MeO_BDE47= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z5_MeO_BDE47= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z5_MeO_BDE47_4_MeO_BDE49= rep('',each=numb,stringsAsFactors = FALSE)
  Z4_MeO_BDE49= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z6_MeO_BDE49= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z2_MeO_BDE68= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z6_MeO_BDE85= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z6_MeO_BDE90= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z6_MeO_BDE99= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z2_MeO_BDE123= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z6_MeO_BDE137= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z8_OH_BDE= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z6_OH_BDE17= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_BDE17= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z5_OH_BDE47= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z6_OH_BDE47_75= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z6_OH_BDE49= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z6_OH_BDE85= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z6_OH_BDE90= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z5_OH_BDE99= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z5_OH_BDE100= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_BDE101= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z4_OH_BDE103= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z2_OH_BDE123= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z6_OH_BDE137= 	rep('',each=numb,stringsAsFactors = FALSE)
  naphthalene= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z2_metylnaphtalene= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z1_metylnaphtalene= 	rep('',each=numb,stringsAsFactors = FALSE)
  biphenyl= 		rep('',each=numb,stringsAsFactors = FALSE)
  acenaphthylene= 	rep('',each=numb,stringsAsFactors = FALSE)
  acenaphthene= 	rep('',each=numb,stringsAsFactors = FALSE)
  dibenzofuran= 	rep('',each=numb,stringsAsFactors = FALSE)
  fluorene= 		rep('',each=numb,stringsAsFactors = FALSE)
  dibenzotiophene= 	rep('',each=numb,stringsAsFactors = FALSE)
  phenanthrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  antracene= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z3_metylphenantrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z2_metylphenantrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z2_metylantracene= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z9_metylphenantrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z1_metylphenantrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  fluoranthene= 	rep('',each=numb,stringsAsFactors = FALSE)
  pyrene= 		rep('',each=numb,stringsAsFactors = FALSE)
  benzo_a_fluorene= 	rep('',each=numb,stringsAsFactors = FALSE)
  retene= 		rep('',each=numb,stringsAsFactors = FALSE)
  benzo_b_fluorene= 	rep('',each=numb,stringsAsFactors = FALSE)
  benzo_ghi_fluoranthene= rep('',each=numb,stringsAsFactors = FALSE)
  cyclopenta_cd_pyrene= rep('',each=numb,stringsAsFactors = FALSE)
  benzo_a_anthracene= 	rep('',each=numb,stringsAsFactors = FALSE)
  chrysene= 		rep('',each=numb,stringsAsFactors = FALSE)
  benzo_bjk_fluoranthene= rep('',each=numb,stringsAsFactors = FALSE)
  benzo_b_fluoranthene= rep('',each=numb,stringsAsFactors = FALSE)
  benzo_k_fluoranthene= rep('',each=numb,stringsAsFactors = FALSE)
  benzo_a_fluoranthene= rep('',each=numb,stringsAsFactors = FALSE)
  benzo_e_pyrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  benzo_a_pyrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  perylene= 		rep('',each=numb,stringsAsFactors = FALSE)
  indeno_123_cd_pyrene= rep('',each=numb,stringsAsFactors = FALSE)
  dibenzo_ac_ah_antracen= rep('',each=numb,stringsAsFactors = FALSE)
  benzo_ghi_perylen= 	rep('',each=numb,stringsAsFactors = FALSE)
  antanthrene= 		rep('',each=numb,stringsAsFactors = FALSE)
  coronene= 		rep('',each=numb,stringsAsFactors = FALSE)
  dibenz_ae_pyrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  dibenz_ai_pyrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  dibenz_ah_pyrene= 	rep('',each=numb,stringsAsFactors = FALSE)
  SCCP= 		rep('',each=numb,stringsAsFactors = FALSE)
  MCCP= 		rep('',each=numb,stringsAsFactors = FALSE)
  siloxane_D5= 		rep('',each=numb,stringsAsFactors = FALSE)
  nonPH= 		rep('',each=numb,stringsAsFactors = FALSE)
  octPH= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z135TriCHLB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z123TriCHLB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z124TriCHLB= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z2378_TCDD= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z12378_PeCDD= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z123478_HxCDD= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z123678_HxCDD= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z123789_HxCDD= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z1234678_HpCDD= 	rep('',each=numb,stringsAsFactors = FALSE)
  OCDF= 		rep('',each=numb,stringsAsFactors = FALSE)
  OCDD= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z2378_TCDF= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z12378_12348_PeCDF= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z23478_PeCDF= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z123478_123479_HxCDF= rep('',each=numb,stringsAsFactors = FALSE)
  Z123678_HxCDF= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z123789_HxCDF= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z234678_HxCDF= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z1234678_HpCDF= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z1234789_HpCDF= 	rep('',each=numb,stringsAsFactors = FALSE)
  TiBP= 		rep('',each=numb,stringsAsFactors = FALSE)
  TCEP= 		rep('',each=numb,stringsAsFactors = FALSE)
  TCPP= 		rep('',each=numb,stringsAsFactors = FALSE)
  TDCPP= 		rep('',each=numb,stringsAsFactors = FALSE)
  TBEP= 		rep('',each=numb,stringsAsFactors = FALSE)
  TEHP= 		rep('',each=numb,stringsAsFactors = FALSE)
  TPhP= 		rep('',each=numb,stringsAsFactors = FALSE)
  EHDPP= 		rep('',each=numb,stringsAsFactors = FALSE)
  ToCrP= 		rep('',each=numb,stringsAsFactors = FALSE)
  TCrP= 		rep('',each=numb,stringsAsFactors = FALSE)
  DBPhP= 		rep('',each=numb,stringsAsFactors = FALSE)
  DPhBP= 		rep('',each=numb,stringsAsFactors = FALSE)
  MeHg= 		rep('',each=numb,stringsAsFactors = FALSE)
  Hg= 			rep('',each=numb,stringsAsFactors = FALSE)
  CN_33_34_37= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_47= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_28_43= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_32= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_35= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_52_60= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_58= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_61= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_57= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_62= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_53= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_59= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_63= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_64_68= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_65= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_66_67= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_69= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_71_72= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_73= 		rep('',each=numb,stringsAsFactors = FALSE)
  CN_74= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z1357_TeCN= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z1256_TeCN= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z2367_TeCN= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z12357_PeCN= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z12367_PeCN= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z12358_PeCN= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z123467_HxCN_123567_HxCN= rep('',each=numb,stringsAsFactors = FALSE)
  Z123568_HxCN= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z124568_HxCN_124578_HxCN= rep('',each=numb,stringsAsFactors = FALSE)
  Z123678_HxCN= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z1234567_HpCN= 	rep('',each=numb,stringsAsFactors = FALSE)
  Z1234568_HpCN= 	rep('',each=numb,stringsAsFactors = FALSE)
  TCN= 			rep('',each=numb,stringsAsFactors = FALSE)
  Z1245_TeCBz= 		rep('',each=numb,stringsAsFactors = FALSE)
  Z1234_TeCBz= 		rep('',each=numb,stringsAsFactors = FALSE)
  HxCBz= 		rep('',each=numb,stringsAsFactors = FALSE)
  PnCBz= 		rep('',each=numb,stringsAsFactors = FALSE)
  TCPM= 		rep('',each=numb,stringsAsFactors = FALSE)
  BB101= 		rep('',each=numb,stringsAsFactors = FALSE)
  length= 		rep('',each=numb,stringsAsFactors = FALSE)
  tuskvol= 		rep('',each=numb,stringsAsFactors = FALSE)
  CHB_40_41= 		rep('',each=numb,stringsAsFactors = FALSE)
  lipid_weight= 	rep('',each=numb,stringsAsFactors = FALSE)
  tusk_length= 		rep('',each=numb,stringsAsFactors = FALSE)
  tusk_girth= 		rep('',each=numb,stringsAsFactors = FALSE)
  op_DDT_pp_DDD= 	rep('',each=numb,stringsAsFactors = FALSE)
  PCB_74_76 = 		rep('',each=numb,stringsAsFactors = FALSE)

 
  df =  data.frame(project,laboratory,species,age,sex,age_group,matrix,sample_id,
        NPI_sample_id,lab_id,fat_percentage,date_sample_collected,date_report,latitude,
        longitude,placename,ownership,excel_uri,excel_filename,excel_type,excel_length,comment,
  	first_name,last_name,organisation,corrected_blank_contamination,
  	percent_recovery,unit,detection_limit,HCB,a_HCH,b_HCH,g_HCH,
  	heptachlor,oxy_CHL,t_CHL,c_CHL,tn_CHL,cn_CHL,op_DDE,pp_DDE,
  	op_DDD,pp_DDD,op_DDT,pp_DDT,mirex,aldrin,dieldrin,endrin,
  	heptachlor_epoxide,CHB_26,CHB_40,CHB_41,CHB_44,CHB_50,
  	CHB_62,PCB_28,PCB_29,PCB_31,PCB_47,PCB_52,PCB_56,
  	PCB_66,PCB_74,PCB_87,PCB_99,PCB_101,PCB_105,PCB_110,
  	PCB_112,PCB_114,PCB_118,PCB_123,PCB_128,PCB_132,PCB_136,
  	PCB_137,PCB_138,PCB_141,PCB_149,PCB_151,PCB_153,PCB_156,
  	PCB_157,PCB_167,PCB_170,PCB_180,PCB_183,PCB_187,PCB_189,
  	PCB_194,PCB_196,PCB_199,PCB_206,PCB_207,PCB_209,BDE_28,
  	BDE_47,BDE_77,BDE_99,BDE_100,BDE_153,BDE_154,BDE_183,
  	BDE_206,BDE_207,BDE_208,BDE_209,HBCDD,PBT,PBEB,DPTE,
  	HBB,PCP,Z4_OH_CB106,Z4_OH_CB107,Z4_OH_CB108,Z3_OH_CB118,
  	Z4_OH_BDE42,Z3_OH_BDE47,Z6_OH_BDE47,Z4_OH_BDE49,Z2_OH_BDE68,
  	Z4_OH_CB130,Z3_OH_CB138,Z4_OH_CB146,Z4_OH_CB159,Z4_OH_CB172,
  	Z3_OH_CB180,Z4_OH_CB187,PFHxA,PFHpA,PFOA,PFNA,PFDA,
  	PFUnDA,PFDoDA,PFTrDA,PFTeDA,PFBS,PFHxS,PFOS,FOSA,
  	N_MeFOSA,N_MeFOSE,N_EtFOSA,N_EtFOSE,reference,brPFOS,
  	linPFOS,PFOSbr2,PFOSlin2,FTSA,PFHpS,PFPeA,PFPeDA,PECB,
  	PFNS,PFDS,PFBA,Z1_3_DCB,Z1_4_DCB,Z1_2_DCB,Z1_3_5_TCB,
  	Z1_2_4_TCB,Z1_2_3_TCB,hexachlorobutadiene,Z1_2_3_4_TTCB,
  	pentachloroanisole,octachlorostyrene,a_endosulfan,
  	b_endosulfan,methoxychlor,Z4_2_FTS,Z6_2_FTS,Z8_2_FTS,
  	Z8_2_FTCA,Z8_2_FTUCA,Z10_2_FTCA,Z10_2_FTUCA,CHB_32,
  	CHB_38,CHB_58,CHB_69,BCP,Z3_MeSO2_DDE,CDT,DDE_PCB_87,
        OCS,photomirex,HCBD,ChCl,MC6,B6_923a,B7_499,B7_515,
  	B7_1474_B7_1440,B7_1001,B7_1059a,B7_1450,B8_531,B8_789,
  	B8_806,B8_810,B8_1412,B8_1413,B8_1414,B8_1471,B8_2229,
  	B9_715,B9_718,B9_743_B9_2006,B9_1025,B9_1046,B9_1679,
  	B10_1110,PCB_1,PCB_3,PCB_4_10,PCB_6,PCB_7_9,PCB_8_5,
  	PCB_12_13,PCB_15_17,PCB_16_32,PCB_18,PCB_19,PCB_20,
  	PCB_22,PCB_24_27,PCB_25,PCB_26,PCB_28_31,PCB_31_28,
  	PCB_33,PCB_33_20,PCB_37,PCB_38,PCB_40,PCB_42,PCB_43,
  	PCB_44,PCB_45,PCB_46,PCB_48,PCB_49,PCB_47_48,PCB_47_49,
  	PCB_50,PCB_51,PCB_53,PCB_54_29,PCB_55,PCB_56_60,
  	PCB_59,PCB_60,PCB_63,PCB_64,PCB_64_41,PCB_66_95,
  	PCB_70,PCB_70_74,PCB_70_76,PCB_70_76_98,PCB_71_41_64,
  	PCB_76,PCB_77,PCB_81,PCB_81_87,PCB_82,PCB_83,PCB_84,
  	PCB_85,PCB_91,PCB_92,PCB_95,PCB_97,PCB_99_113,PCB_100,
  	PCB_101_90,PCB_107,PCB_113,PCB_114_122,PCB_119,PCB_122,
  	PCB_126,PCB_129,PCB_129_178,PCB_130,PCB_133,PCB_134_131,
  	PCB_135_144,PCB_138_164,PCB_146,PCB_147,PCB_157_201,PCB_158,
  	PCB_163_138,PCB_169,PCB_170_190,PCB_171,PCB_171_202,
  	PCB_171_202_156,PCB_172,PCB_172_192,PCB_173,PCB_174,PCB_175,
  	PCB_176,PCB_177,PCB_178,PCB_179,PCB_180_193,PCB_182_187,
  	PCB_185,PCB_191,PCB_193,PCB_195,PCB_196_203,PCB_197,
  	PCB_198,PCB_200,PCB_201,PCB_201_204,PCB_202,PCB_202_171,
  	PCB_203,PCB_203_196,PCB_204,PCB_205,PCB_208,PCB_208_195,
  	PCB_138_163,PCB_153_132,Z4_OH_CB79,Z3_OH_CB85,Z4_OH_CB97,
        Z4_OH_CB104,Z4_OH_CB107_4_OH_CB108,Z4_OH_CB112,
  	Z2_OH_CB114,Z4_OH_CB120,Z4_OH_CB127,Z4_OH_CB134,
  	Z3_OH_CB153,Z4_OH_CB162,Z4_OH_CB163,Z4_OH_CB165,
  	Z4_OH_CB177,Z4_OH_CB178,Z3_OH_CB182,Z3_OH_CB183,
  	Z3_OH_CB184,Z4_OH_CB193,Z4_OH_CB198,Z4_OH_CB199,
  	Z4_OH_CB200,Z4_OH_CB201,Z4_OH_CB202,Z44_diOH_CB202,
  	Z3_OH_CB203,Z4_OH_CB208,Z10_OH_CB,Z3_MeSO2_CB49,Z4_MeSO2_CB49,
  	Z3_MeSO2_CB52,Z4_MeSO2_CB52,Z4_MeSO2_CB64,Z3_MeSO2_CB70,
  	Z4_MeSO2_CB70,Z3_MeSO2_CB87,Z4_MeSO2_CB87,Z3_MeSO2_CB91,
  	Z4_MeSO2_CB91,Z3_MeSO2_CB101,Z4_MeSO2_CB101,Z3_MeSO2_CB110,
  	Z4_MeSO2_CB110,Z3_MeSO2_CB149,Z4_MeSO2_CB149,
  	Z3_MeSO2_CB132,Z4_MeSO2_CB132,Z3_MeSO2_CB141,Z4_MeSO2_CB141,
  	Z3_MeSO2_CB174,Z4_MeSO2_CB174,Z19_MeSO2_CB,BDE_17,BDE_25,
  	BDE_49,BDE_54,BDE_66,BDE_71,BDE_71_49,BDE_75,BDE_85,
  	BDE_116,BDE_119,BDE_126,BDE_138,BDE_139,BDE_140,BDE_155,
  	BDE_100_5_MeO_BDE47,BDE_154_BB153,BDE_156,BDE_171,
  	BDE_180,BDE_181,BDE_184,BDE_190,BDE_191,BDE_196,BDE_197,
  	BDE_201,BDE_202,BDE_203,BDE_205,BDE_208_207,a_HBCD,b_HBCD,
  	g_HBCD,TBPA,BTBPE,TBB,TBBPA_DBPE,DPDPE,ATE,BEHTBP,TBP,BTBPI,
  	TBBPA_DAE,EHTBB,DBDPE,TBA,TBBPA,Z4_OH_HpCS,Z44_DiBB,Z2255_TetBB,
  	Z224455_HexBB,Z6_MeO_BDE17,Z4_MeO_BDE17,Z2_MeO_BDE28,Z4_MeO_BDE42,
  	Z6_MeO_BDE47,Z3_MeO_BDE47,Z5_MeO_BDE47,Z5_MeO_BDE47_4_MeO_BDE49,
  	Z4_MeO_BDE49,Z6_MeO_BDE49,Z2_MeO_BDE68,Z6_MeO_BDE85,Z6_MeO_BDE90,
  	Z6_MeO_BDE99,Z2_MeO_BDE123,Z6_MeO_BDE137,Z8_OH_BDE,Z6_OH_BDE17,
  	Z4_OH_BDE17,Z5_OH_BDE47,Z6_OH_BDE47_75,Z6_OH_BDE49,Z6_OH_BDE85,
  	Z6_OH_BDE90,Z5_OH_BDE99,Z5_OH_BDE100,Z4_OH_BDE101,Z4_OH_BDE103,
  	Z2_OH_BDE123,Z6_OH_BDE137,naphthalene,Z2_metylnaphtalene,
  	Z1_metylnaphtalene,biphenyl,acenaphthylene,acenaphthene,
  	dibenzofuran,fluorene,dibenzotiophene,phenanthrene,antracene,
  	Z3_metylphenantrene,Z2_metylphenantrene,Z2_metylantracene,
  	Z9_metylphenantrene,Z1_metylphenantrene,fluoranthene,pyrene,
  	benzo_a_fluorene,retene,benzo_b_fluorene,benzo_ghi_fluoranthene,
  	cyclopenta_cd_pyrene,benzo_a_anthracene,chrysene,
  	benzo_bjk_fluoranthene,benzo_b_fluoranthene,benzo_k_fluoranthene,
  	benzo_a_fluoranthene,benzo_e_pyrene,benzo_a_pyrene,
  	perylene,indeno_123_cd_pyrene,dibenzo_ac_ah_antracen,
  	benzo_ghi_perylen,antanthrene,coronene,dibenz_ae_pyrene,
  	dibenz_ai_pyrene,dibenz_ah_pyrene,SCCP,MCCP,siloxane_D5,
  	nonPH,octPH,Z135TriCHLB,Z123TriCHLB,Z124TriCHLB,
  	Z2378_TCDD,Z12378_PeCDD,Z123478_HxCDD,Z123678_HxCDD,
  	Z123789_HxCDD,Z1234678_HpCDD,OCDF,OCDD,Z2378_TCDF,
  	Z12378_12348_PeCDF,Z23478_PeCDF,Z123478_123479_HxCDF,
  	Z123678_HxCDF,Z123789_HxCDF,Z234678_HxCDF,Z1234678_HpCDF,
  	Z1234789_HpCDF,TiBP,TCEP,TCPP,TDCPP,TBEP,TEHP,
  	TPhP,EHDPP,ToCrP,TCrP,DBPhP,DPhBP,MeHg,Hg,CN_33_34_37,
  	CN_47,CN_28_43,CN_32,CN_35,CN_52_60,CN_58,CN_61,CN_57,
  	CN_62,CN_53,CN_59,CN_63,CN_64_68,CN_65,CN_66_67,CN_69,
  	CN_71_72,CN_73,CN_74,Z1357_TeCN,Z1256_TeCN,Z2367_TeCN,
  	Z12357_PeCN,Z12367_PeCN,Z12358_PeCN,Z123467_HxCN_123567_HxCN,
  	Z123568_HxCN,Z124568_HxCN_124578_HxCN,Z123678_HxCN,
  	Z1234567_HpCN,Z1234568_HpCN,TCN,Z1245_TeCBz,Z1234_TeCBz,
  	HxCBz,PnCBz,TCPM,BB101,length,tuskvol,CHB_40_41,lipid_weight,
  	tusk_length,tusk_girth,op_DDT_pp_DDD,PCB_74_76)

#Store in excel file	
exc <- loadWorkbook(outExcelfile, create = TRUE)
createSheet(exc,'Input')
writeWorksheet(exc, df, sheet = "Input", startRow = 1, startCol = 1)
saveWorkbook(exc) 

}



createExcel()


