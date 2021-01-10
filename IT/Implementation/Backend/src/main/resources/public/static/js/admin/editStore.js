$(document).ready(function () {
    $.ajax({
        url: '/api/store/getMyStore',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (data) {
            buildStoreInformation(data);
        }
    });

    $.ajax({
        url: '/api/store/getStoreSlots',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (data) {
            buildStoreSlot(data)
        }
    })
});

function buildStoreInformation(data) {
    var storeContainer = new Vue({
        el: '#storeContainer',
        data: {
            data
        },
        methods: {

        }
    });
}

function buildStoreSlot(data) {
    var slotContainer = new Vue({
        el: '#slotContainer',
        data: {
            data
        },
        methods: {

        }
    });
}