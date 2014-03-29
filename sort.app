@ = require(['mho:app','mho:std']);

@mainContent .. @appendContent([`
    <div class="question">
    <div class="container">
      <div class="row">
        <div class="col-md-3">
        </div><!-- end md-4 -->
        
        <div class="col-md-6">
          <div class="question-text">
            <h1>Which fruit would you choose for lunch, based on what you see below?</h1>
          </div><!-- end image -->
        </div><!-- end md-5 -->
        
        <div class="col-md-3">
        </div><!-- end md-4 -->

      </div> <!-- end row -->
    </div><!-- End Container -->
  </div><!-- question -->
`,
@RequireExternalStyle('/style.css')]);

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
  <div class="content">
    <div class="container">
      <div class="row">
        <div class="a col-md-5">
          <div class="image b-img">
          </div><!-- end image -->
        </div><!-- end md-5 -->
        
        <div class=" col-md-2">
          <div class="or">
            <p>or<p>
          </div><!-- end image -->
        </div><!-- end md-5 -->
        
        <div class="b col-md-5">
          <div class="image a-img">
          </div><!-- end image -->
        </div><!-- end md-5 -->

      </div> <!-- end row -->
    </div><!-- End Container -->
  </div><!-- End Cotent -->
    `
    .. @Style("
    .a-img { background-image: url('#{a.images .. pickRand}');}
    .b-img { background-image: url('#{b.images .. pickRand}');}
    ")
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
