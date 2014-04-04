@ = require([
  'mho:app',
  'sjs:nodejs/fs', 
  'sjs:sequence', 
  'sjs:object', 
  'sjs:sjcl',
  './sortdb',
]);

//initialize
var 
  topicRoot = './topics',
  stats,
  topics,
  topicFiles,
  identifier;

//initialization
(function(){
  topics = @readdir(topicRoot) .. @filter(d->@isDirectory(topicRoot+'/'+d)) .. @toArray;
  
  identifier = topics .. @join .. @hash.sha256.hash .. @codec.base64.fromBits;

  stats = @getStatistics(identifier);

  topicDisplayImages = @readdir(topicRoot)
    .. @filter(d->@isDirectory(topicRoot+'/'+d))
    .. @map( topic -> {topic:topic, image: '/topics/'+topic+'/'+@readdir(topicRoot+"/"+topic)
        .. @filter(f->@isFile(topicRoot+"/"+topic+'/'+f)) 
        .. @find( f->f.indexOf('display')==0 )}
    ) .. @toArray;

  topicEndImages = @readdir(topicRoot)
    .. @filter(d->@isDirectory(topicRoot+'/'+d))
    .. @map( topic -> {topic:topic, image: '/topics/'+topic+'/'+@readdir(topicRoot+"/"+topic)
        .. @filter(f->@isFile(topicRoot+"/"+topic+'/'+f)) 
        .. @find( f->f.indexOf('end')==0 )}
    ) .. @toArray;
})();

/**
 [ {topic:'topic1', image:'/topics/topic1/display.jpg'}, ... ] 
 */
exports.getTopicDisplayImages = function(){ return topicDisplayImages; };

/**
 [ {topic:'topic1', image:'/topics/topic1/display.jpg'}, ... ] 
 */
exports.getTopicEndImages = function(){ return topicEndImages; };

exports.getStatistics = function(){ return stats; }

/**
 a client's result should look like the following topic format: 
 { order:["topic1", "topic2", "topic3", etc..]}
 any additional information will also be stored
 */
exports.storeResults = function(results){
  var 
    points = results.order.length,
    resultId;

  //check if statistics exist
  if (!stats){
    stats = {};
    stats.topics = topics .. @map(k->[k,0]) .. @pairsToObject;
    stats.participants = 0;
  }
 
  //update statistics
  results.order .. @each{
    |topic|
    stats.topics[topic] += --points;
  }
  stats.participants = stats.participants + 1;

  waitfor {
    //update statistics record
    @putStatistics(identifier, stats);
  } and {
    //store inquiry record, add the id of the inquiry
    results.inquiryId = identifier;
    resultId = @putInquiry(results);
  }
  return resultId;
}

