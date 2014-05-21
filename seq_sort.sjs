@ = require(['mho:std']);

exports.blockingSort = function (seq, compare){
  if (!seq.length) return [];

  var result=[seq[0]], i=1;
  for (i=1; i<seq.length; i++){
    var item = seq[i];
    //console.log(item)
    var min=0, max=result.length;

    //console.log("min: "+min+" max: "+max);
    while (min !== max){
      //console.log('loop');
      var mid = min + Math.round((max-min)/2);
      if (compare(item, result[mid-1])){
        max = mid-1;
      } else {
        min = mid;
      }
    //console.log("min: "+min+" max: "+max);
    }
   //console.log("inserting '#{item}' at #{max}") ;
    result.splice(max, 0, item);
    //console.log(result); 
  }

  return result;
};
