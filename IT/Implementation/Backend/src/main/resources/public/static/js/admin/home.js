$(document).ready(function () {
    $.ajax({
        url: '/api/store/getMyStore',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (data) {
            buildStoreInformation(data);
        },
        error: function (err) {
            if(err.status == 403) {
                window.location.href = '/';
            }
        }
    });
    $.ajax({
        url: '/api/ticket/getMyStoreUpcomingTickets',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (data) {
            buildTicketsInformation(data);
        }
    })
});

function buildStoreInformation(data) {
    var storeContainer = new Vue({
        el: '#storeContainerElement',
        data: {
            data
        },
        methods: {
            buildMap(longitude, latitude) {
                var map = document.createElement("div");
                map.className = "map";
                map.id = "map1";
                document.getElementById("mapContainer").appendChild(map);
                var map1 = L.map('map1').setView([latitude, longitude], 16.5);
                var OSM_layer = L.tileLayer('https://{s}.tile.osm.org/{z}/{x}/{y}.png',
                    {attribution: '&copy; <a href="https://osm.org/copyright">OpenStreetMap</a>'}).addTo(map1);
                var marker = L.marker([latitude, longitude]).addTo(map1);
                document.getElementById('actionButton').innerText = "Hide Map";
                document.getElementById('actionButton').onclick = null;
                document.getElementById('actionButton').onclick = function () {
                    document.getElementById('mapContainer').innerHTML = "";
                    document.getElementById('actionButton').innerText = "Show Map"
                    document.getElementById('actionButton').onclick = buildMap(longitude, latitude);
                }
            }
        }
    });
}

function buildTicketsInformation(data) {
    var ticketsContainer = new Vue({
        el: '#ticketsContainer',
        data: {
            data
        },
        methods: {
            substring: function (str) {
                return str.substr(0, 10);
            },
        }
    });
}