@ = require([
  'mho:server/storage', 
  'sjs:nodejs/fs', 
  'sjs:sequence', 
  'sjs:object', 
  'sjs:sjcl',
]);

var db = @Storage('./sortDB');

/**
 key: stats/<sha256-of-joined-topics>
 if the stats do not exist, undefined is returned.
 the hash ensures that when the topics change a new session is started>
 */
exports.getStatistics = function(id){
  try {
    var result = db.get('stats/'+id);
    if (result) 
      return JSON.parse(result.toString());
  } catch(e){};
}

exports.putStatistics = function(id, statistics){
  db.put('stats/'+id, JSON.stringify(statistics));
}


/**
 key: inquiry/<some-unique-hash>
 an inquiry is uniquely stored unrelated to its set of topics
*/
exports.getInquiry = function(id){
  try {
    var result = db.get('inquiry/'+id);
    if (result) 
      return JSON.parse(result.toString());
  } catch(e){};
}

function keyAvailable(key){
  try {
    db.get(key);
    return false;
  } catch(e){
    return true;
  }
}

exports.putInquiry = function(inquiryData){
  var id;
  do {
    id = @hash.sha256.hash((new Date).getTime()) .. @codec.base64.fromBits;  
  } while (!keyAvailable('inquiry/'+id));
  db.put('inquiry/'+id, JSON.stringify(inquiryData));
  return id;
}

