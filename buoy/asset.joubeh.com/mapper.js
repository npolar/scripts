map = {
  "300234062447650": "BUOY_1",
  "300234062442640": "BUOY_2",
  "300234062447630": "NICE_2015_CALIB1",
  "300234062440630": "NICE_2015_CALIB2",
  "300234061371430": "NICE_2015_CALIB3",
  "300234061362150": "NICE_2015_CALIB4",
  "300234061369130": "NICE_2015_CALIB5",
  "300234061269230": "NICE_2015_CALIB6",
  "300234061369140": "NICE_2015_CALIB7",
  "300234062311650": "NICE_2015_SNOW1",
  "300234062426150": "NICE_2015_SNOW2",
  "300234062424060": "S22",
  "300234062426060": "S23",
  "300234011090780": "LANCE1",
  "300234010080470": "LANCE2",
  "300234010084440": "LANCE3",
  "300234011091510": "LANCE4",
  "300234062726310": "N-ICE_AFAR1",
  "300234062317630": "N-ICE_AFAR2",
  "300234062722280": "N-ICE_AFAR3",
  "300234062316640": "N-ICE_AFAR4",
};

swap = function (json) {
  var ret = {};
  for(var key in json){
    ret[json[key]] = key;
  }
  return ret;
};

wash = function (str) {
  return Number(str.replace(/[^1-9 ]/g, "").replace(" ", "."));
};

functions = {
  /*
  Filename include IMEI number or buoy name.
  This matches IMEI with buoy name.
  */
  "namesAndIMEI": function (data) {
    if (data.IMEI) {
      data.title = map[data.IMEI];
    } else if (data.title) {
      data.IMEI = swap(map)[data.title];
    }
    return data;
  },
  "washLatLng": function (data) {
    data.latitude = wash(data.latitude);
    data.longitude = wash(data.longitude);
    return data;
  },
  "fixDates": function (data) {
    data.measured = data.measured.replace(" ", "T")+"Z";
    return data;
  }
};
