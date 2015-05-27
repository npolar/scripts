functions = {
  /*
    FTP filename include buoy name. This is injected in the title property.
    This matches name with IMEI
   */
  "IMEIFromName": function (data) {
    switch (data.title) {
      case "NPOL_04":
        data.IMEI = "300234061760870";
        break;
      case "NPOL_05":
        data.IMEI = "300234061762880";
        break;
      case "FMI_13":
        data.IMEI = "300234060690060";
        break;
      case "FMI_14":
        data.IMEI = "300234060695050";
        break;
      case "FMI_19":
        data.IMEI = "300234060669770";
        break;
      case "FMI_20":
        data.IMEI = "300234060666760";
        break;
      default:

    }
    return data;
  }
};
