//Store map
function buildMap(latitude, longitude) {
    var map1 = L.map('map1').setView([latitude, longitude], 16.5);
    var OSM_layer = L.tileLayer('https://{s}.tile.osm.org/{z}/{x}/{y}.png',
        {attribution: '&copy; <a href="https://osm.org/copyright">OpenStreetMap</a>'}).addTo(map1);
    var marker = L.marker([latitude, longitude]).addTo(map1);
}