@ = require([
  'mho:app',
  'mho:std',
  './seq_sort.sjs',
]);

document.body .. @prependContent([`
    <div class="visible-landscape-xs overlay">
      <div class="col-xs-12">
        <img src="/img/turnmobile.png" class="center-block"/>
        <p>Rotate telephone</p>
      </div>
    </div>
    <div class="question">
    <div class="container">
      <div class="row">
        <div class="col-xs-3">
        </div
        
        <div class="col-xs-6">
          <div class="question-text">
            <h1>Which font appears most trustworthy to you</h1>
          </div>
        </div>
        
        <div class="col-xs-3">
        </div>

      </div> 
    </div>
  </div>
`,
@RequireExternalStyle('/css/combi_vanilla.css')]);

var candidates;

__js var pickRand = a->a[Math.ceil(Math.random()*(a.length-1))];

function isBetter(a, b){
  var wrpImg = t->@Img({src:t.image}) .. @Style('{width:200px}');
  @mainContent .. @appendContent(
    `
  <div class="content">
    <div class="container">
      <div class="row hidden-portrait-xs results-row">
        <div class="a col-sm-5 col-xs-6">
          <div>
            <img class="image" src="${a.image}"/>
          </div>
        </div>
        
        <div class="col-xs-2 hidden-xs"></div>
        
        <div class="b col-sm-5 col-xs-6">
          <div>
            <img class="image" src="${b.image}"/>
          </div>
        </div>
            
        <p class="or hidden-xs">or<p>
      </div>
    </div>
  </div>
    `
   // .. @Style("
   // .a-img { background-image: url('#{a.image}');}
   // .b-img { background-image: url('#{b.image}');}
   // ")
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


@withAPI('./sort.api'){
 |api|
  candidates = api.getTopics();
  var order = candidates .. @blockingSort(isBetter);
  var resultId = api.postResults({order: order .. @map(o->o.topic)});
  location = '/result.html?r='+resultId;
}

