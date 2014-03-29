@ = require(['mho:app','mho:std']);

@withAPI('./sort.api'){
 |api|
 console.log(api.getTopics());
}

var candidates = [
  'apple',
  'pear',
  'melon',
  'grape',
  'pineapple',
  'meatbal',
  'banana',
  'kiwi',
];

function isBetter(a, b){
  @mainContent .. @appendContent(
    `
      <table>
        <tr><td colspan="2"><h1>pick one</h1></td></tr>
        <tr>
          <td class="a">${a}</td>
          <td class="b">${b}</td>
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
  order .. @map( i->@Tr(@Td(i)) ) .. @toArray)
]);
