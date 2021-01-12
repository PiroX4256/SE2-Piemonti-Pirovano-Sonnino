//Store map
function buildMap(longitude, latitude) {
    var map1 = L.map('map1').setView([longitude, latitude], 16.5);
    var OSM_layer = L.tileLayer('https://{s}.tile.osm.org/{z}/{x}/{y}.png',
        {attribution: '&copy; <a href="https://osm.org/copyright">OpenStreetMap</a>'}).addTo(map1);
    var marker = L.marker([longitude, latitude]).addTo(map1);
}