function initMap() {
  var uluru = {lat: 40, lng: -120};
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 4,
    center: uluru
  });
  var marker = new google.maps.Marker({
    position: uluru,
    map: map
  });

  map.data.loadGeoJson('ca-counties.json');
}
