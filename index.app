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

document.body .. @appendContent([`
    <div class="footer">
    	<div class="container">
    		<div class="row">
    		  <div class="col-md-6">
    			  <h1>Pick Your Favourite</h1>
    			  <p>Pick your favourite is a sorting application created by <a href="http://onilabs.com/">Oni Labs</a> to demonstrate the uses of the <a href="http://conductance.io/">Conductance</a> framework.</p>
    			<p>It was originally created to help our graduate student gain insights into his thesis topic “How to convey Trustworthiness in web application” by sorting variables in the order of relevance.</p>
    		  </div><!-- end md-6 -->
		  
		  
    		  <div class="col-md-6">
    		  </div><!-- end md-6 -->
    		  <a href="http://onilabs.com"><img src="img/onilogo01.png" class="footer-logo"/></a>

    		</div> <!-- end row -->
    	</div><!-- End Container -->
    </div><!-- End Cotent -->
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
        <div class="a col-sm-6 col-xs-6">
          <div>
            <img class="image" src="${a.image}"/>
          </div>
        </div>
        
        
        
        <div class="b col-sm-6 col-xs-6">
          <div>
            <img class="image shadow" src="${b.image}"/>
          </div>
        </div>
            
        
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

