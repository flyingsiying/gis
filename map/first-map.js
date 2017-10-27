function initMap() {
  var uluru = {lat: 38, lng: -120};
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 6,
    center: uluru
  });
  loadGeoJson(map);
}

function loadGeoJson(map){
  var caLayer = new google.maps.Data();
  caLayer.loadGeoJson('https://raw.githubusercontent.com/flyingsiying/gis/master/data/ca-counties.json');
  // caLayer.loadGeoJson('https://raw.githubusercontent.com/flyingsiying/gis/master/data/us-states.json');
  caLayer.setStyle({
    fillColor: 'Orange',
    strokeWeight: 2
  });
  caLayer.addListener('mouseover', function(event){
    caLayer.overrideStyle(event.feature, {strokeWeight: 4});
  });
  caLayer.addListener('mouseout', function(event){
    caLayer.revertStyle();
  });
  caLayer.setMap(map);

}
