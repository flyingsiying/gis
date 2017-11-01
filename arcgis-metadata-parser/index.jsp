<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="et" uri="entity.jsp.tag" %>
<c:set var="PageStyles">
  <style type="text/css">
    .checkbox, .alert{
      font-size: 15px
    }
    .panel-heading{
      font-size: 12px
    }
    .panel-body{
      font-size: 10px
    }
    #search-results{
      overflow: auto
    }
  </style>
</c:set>
<c:set var="PageScripts">
  <script type="text/javascript" src="<c:url value="/resources/js/MyForm.js" />"></script>
  <script type="text/javascript" > 
    
    $(document).ready(function () {
      $(".alert").hide();
      
//      if($('input[name=createImage]').is(':checked')){
//        $('input[name=createImage]').attr('value', true);
//      }
//      else{
//        $('input[name=createImage]').attr('value', false);
//      }
//      
//      $('input[name=createImage]').attr('value', $('input[name=createImage]').prop('checked'));
//      $('input[name=assignRank]').attr('value', $('input[name=assignRank]').prop('checked'));

//     
//            var createImage = document.querySelector('input[name=createImage]');
//      var assignRank = document.querySelector('input[name=assignRank]');
//      createImage.value = createImage.checked? true;false;
//      assignRank.value = assignRank.checked? true;false;
      
      new MyForm({
        id: "parserform"
        , listeners: {
          beforeSubmit: function(){
            $(".alert").hide();
            $('input[name=createImage]').attr('value', $('input[name=createImage]').is(':checked'));
            $('input[name=assignRank]').attr('value', $('input[name=assignRank]').is(':checked'));
            window.loadmask.show();
          }
          ,onSuccess: function (response) {
            window.loadmask.hide();
            $(".alert-success").show();
//            alert("success");
          }
          , onSubmitError: function (err, response) {
            window.loadmask.hide();
            console.log(response);
            $(".alert-danger").show();
            alert(err)
          }
        }
      });
      
      new MyForm({
        id: "searchform"
        , listeners: {
          onSuccess: function(response){
            $(".alert").hide();
            $("#search-results").empty();
            for(var i=0; i<response.data.length;i++){
              var div = $("<div " + " class = \"col-lg-6\"></div>");
              var panel = $("<div " + " class = \"panel panel-info\"></div>");
              var panelHeading = $("<div " + " class = \"panel-heading\">" + response.data[i].layerName + "</div>");
              var panelBody = $("<div " + " class = \"panel-body\">" + "</div>");
              panel.append(panelHeading).append(panelBody);
              var colleft = $("<div " + " class = \"col-md-6\"></div>");
              var colright = $("<div " + " class = \"col-md-6\"></div>");
              panelBody.append(colleft).append(colright);
              //left:
              var img = $(document.createElement('img'));
              img.attr('src',"service/thumbnail/" + response.data[i].metadataId);
              img.appendTo(colleft);
              //right:
              var layer = $("<div>Layer: " + "</div>");
              var layerUrl = response.data[i].layerUrl;
              var a = $("<a />",{
                href: layerUrl
                ,html: response.data[i].layerName
              });
              a.appendTo(layer);
              var server = $("<div>Server: " + response.data[i].serviceName + "</div>");
              var service = $("<div>Service: " + response.data[i].serviceName + "</div>");
              var rank = $("<div>Rank: " + response.data[i].layerRank + "</div>");
              colright.append(layer).append(service).append(rank);
//              $a.appendTo(colright);
              //panelbody:
//              rank.appendTo(panelBody);
              panel.appendTo(div);
              div.appendTo("#search-results");
//              div.appendTo("#search-results");
            }
          }
          , onSubmitError: function (err, response){
            console.log(response);
            alert(err)
          }
        }
      });
      
//      var search = $("input[name=search]");
//      search.on('change', function () {
//        $("#search-results").empty();
//        $.ajax({
//          type: "GET",
//          url: "service/search",
//          data: {keywords: search.val()},
//          dataType: 'json',
//          success: function(response){
//            try {
//              if (!response.success) {
//                throw response.error;
//              }
//              for(var i=0; i<response.data.length;i++){
//                var div = $("<div id = metadata" + response.data[i].metadataId + " class = \"col-sm-2\"></div>");
//                var img = $(document.createElement('img'));
//                img.attr('src',"service/thumbnail/" + response.data[i].metadataId);
//                img.appendTo(div);
//                var layerUrl = response.data[i].layerUrl;
//                var a = $("<a href=\"" + layerUrl + "\">"+ response.data[i].layerName +"</a>");
//                a.appendTo(div);
//                div.appendTo("#search-results");
//              }
//            }
//            catch(e) {
//              alert(e);
//            }
//          }
//        });
//      });

    });
  </script>
</c:set>

<c:set var="PageContent">
  <h3 class="page-header">Welcome to ${MyAppContext.getAppProperties().getAppName()}</h3>
      
  <form id="parserform" action="<c:url value="/service/parser" />" method="post">
  <div class="form-group input-group">
      <input name="url" type="text" class="form-control" placeholder="Enter an ArcGIS Rest Server URL"/>
      <span class="input-group-btn">
        <input name="url" type="submit" class="btn btn-default" value="Parse"/>
      </span>
  </div>
  <div class="form-group checkbox">
    <label>
      <input name="createImage" type="checkbox">Parse thumbnail images for service layers
    </label>
  </div>
  <div class="form-group checkbox">
    <col-sm-6>
      <label>
        <input name="assignRank" type="checkbox">Assign a rank to this server (5 is the highest)   
      </label>
    </col-sm-6>
    <col-sm-6>
      <select name="rank">
        <option>1</option>
        <option>2</option>
        <option>3</option>
        <option>4</option>
        <option>5</option>
      </select>
    </col-sm-6>
  </div>
  <div class="panel-body">
    <div class="alert alert-success">
        Your server has been parsed into the database successfully. <a href="#" class="alert-link">View this server</a>.
    </div>
    <div class="alert alert-info">
        Your server has been updated in the database successfully. <a href="#" class="alert-link">View this server</a>.
    </div>
    <div class="alert alert-danger">
        Your server failed to be parsed into the database. <a href="#" class="alert-link">Error</a>.
    </div>
  </div>
  </form>
  
  <form id="searchform" action="<c:url value="/service/search" />" method="get">
  <div class="form-group input-group">
      <Input name="keywords" type="text" class="form-control" placeholder="Enter keywords"/>
      <span class="input-group-btn">
        <input name="keywords" type="submit" class="btn btn-default" value="Search"/>
      </span>
  </div>
  </form>

  <div id="search-results"></div>

</c:set>
<%@include file="templates/page.jsp" %>