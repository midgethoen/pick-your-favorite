@ = require(['mho:app','mho:std']);

var candidates;

@withAPI('./sort.api'){
 |api|
  candidates = api.getTopics();
}
console.log(candidates);


var pickRand = a->a[Math.ceil(Math.random()*(a.length-1))];

function isBetter(a, b){
  var wrpImg = t->@Img({src:pickRand(t.images)}) .. @Style('{width:200px}');
  @mainContent .. @appendContent(
    `
      <table>
        <tr><td colspan="2"><h1>pick one</h1></td></tr>
        <tr>
          <td class="a">${wrpImg(a)}</td>
          <td class="b">${wrpImg(b)}</td>
        </tr>
      </table>
    `
  ){
    |table|
    waitfor{
      table.querySelector('.a') .. @wait('click');
      return true;
    } or {
      table.querySelector('.b') .. @wait('click');
      return false;
    }
  }
}

var order = [candidates.shift()];

while (candidates.length){
  var candidate = candidates.shift();
  var min=0, max=order.length;
  while (min !== max){
    var mid = min + Math.round((max-min)/2);
    if (isBetter(candidate, order[mid-1])){
      min = mid;
    } else {
      max = mid-1;
    }
  }
  order.splice(max-1, 0, candidate);
}

@mainContent .. @appendContent([
  `<h1>Tadaaa</h1>`,
  @Table(
  order .. @map( i->@Tr(@Td(i.topic)) ) .. @toArray)
]);
