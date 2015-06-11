var extras = {
  "NPOL_01": {
    "deployment date": "2015-01-14T22:00:40Z",
    "deployment lat": 83.2463,
    "deployment lon": 21.6447,
    "name": "SIMBA_2015a",
    "old name": "NPOL_01",
    "owner": "NPI",
    "type": "SRSL IMB",
    "IMEI": "300234061760870"
  },
  "NPOL_03": {
    "deployment date": "2015-01-15T23:02:13Z",
    "deployment lat": 83.0458,
    "deployment lon": 21.9495,
    "name": "SIMBA_2015b",
    "old name": "NPOL_03",
    "owner": "NPI",
    "type": "SRSL IMB",
    "IMEI": "300234061760870"
  },
  "NPOL_04": {
    "deployment date": "2015-04-22T13:00:00Z",
    "deployment lat": 82.8576,
    "deployment lon": 16.5728,
    "name": "SIMBA_2015c",
    "old name": "NPOL_04",
    "owner": "NPI",
    "type": "SRSL IMB",
    "IMEI": "300234061760870"
  },
  "NPOL_05": {
    "deployment date": "2015-03-07T13:53:00Z",
    "deployment lat": 83.1578,
    "deployment lon": 23.7701,
    "name": "SIMBA_2015d",
    "old name": "NPOL_05",
    "owner": "NPI",
    "type": "SRSL IMB",
    "IMEI": "300234061762880"
  },
  "FMI_14": {
    "deployment date": "2015-01-26T18:02:00Z",
    "deployment lat": 83.0472,
    "deployment lon": 18.716,
    "name": "SIMBA_2015e",
    "old name": "FMI_14",
    "owner": "FMI",
    "type": "SRSL IMB",
    "IMEI": "300234060695050"
  },
  "FMI_19": {
    "deployment date": "2015-03-17T01:03:00Z",
    "deployment lat": 80.8043,
    "deployment lon": 19.2689,
    "name": "SIMBA_2015f",
    "old name": "FMI_19",
    "owner": "FMI",
    "type": "SRSL IMB",
    "IMEI": "300234060669770"
  },
  "FMI_20": {
    "deployment date": "2015-01-29T17:00:00Z",
    "deployment lat": 83.0905,
    "deployment lon": 17.0404,
    "name": "SIMBA_2015g",
    "old name": "FMI_20",
    "owner": "FMI",
    "type": "SRSL IMB",
    "IMEI": "300234060666760"
  }
};

var getExtra = function (doc) {
  var extra = extras[doc.title];
  var measured = new Date(doc.measured);
  if (extra instanceof Array) {
    var deploys = extra.map(function (obj, i, arr) {
      obj._date = new Date(obj["deployment date"]);
      return obj;
    });
    deploys = deploys.sort(function(a,b){
      return b._date - a._date;
    });

    for (var i in deploys) {
      if (measured >= deploys[i]._date) {
        return deploys[i];
      }
    }
  }
  return extra;
};

var functions = {
  "fixDates": function (doc) {
    doc.measured = doc.measured.replace(" ", "T")+"Z";
    return doc;
  },
  "deployment": function (doc) {
    var extra = getExtra(doc);
    if (extra) {
      var measured = new Date(doc.measured);
      if (measured >= new Date(extra["deployment date"])) {
        doc.deployment = {
          date: extra["deployment date"],
          latitude: extra["deployment lat"],
          longitude: extra["deployment lon"]
        };
      }
      if (!("deployment" in doc)) {
        doc = null;
      }
    }
    return doc;
  },
  "extras" : function (doc) {
    if (!Object.keys(doc).length) {
      return null;
    }
    var extra = getExtra(doc);
    if (extra) {
      doc.owner = extra.owner;
      doc.type = extra.type;
      doc.title = extra.name;
      doc.IMEI = extra.IMEI;
    }
    doc.id = doc._id;
    return doc;
  }
};
