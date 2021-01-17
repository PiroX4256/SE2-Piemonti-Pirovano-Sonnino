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
        methods: {}
    });
}

function buildStoreSlot(data) {
    var slotContainer = new Vue({
        el: '#slotContainer',
        data: {
            data
        },
        methods: {
            deleteSlot(slotId) {
                $.ajax({
                    url: '/api/store/deleteSlot?slotId=' + slotId,
                    method: 'GET',
                    headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
                    success: function (data) {
                        $('#confirmationModal').modal('show');
                    },
                    error: function (err) {
                        console.log(err);
                    }
                })
            }
        }
    });
}

function editStoreInformation() {
    const form = document.storeForm;
    for (var i = 0; i < form.elements.length; i++) {
        if (form.elements[i].value === '' && form.elements[i].hasAttribute('required')) {
            document.getElementById('errorMessageContent').innerText = "Some required fields are missing, please check them and submit the form again.";
            $('#errorModal').modal('show');
            return false;
        }
    }
    const jsonReq = {
        id: form.id.value,
        name: form.name.value,
        chain: form.chain.value,
        address: form.address.value,
        city: form.city.value,
        cap: form.cap.value,
        longitude: form.longitude.value,
        latitude: form.latitude.value
    };
    console.log(jsonReq);
    $.ajax({
        url: '/api/store/editStore',
        method: 'POST',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        contentType: 'application/json',
        data: JSON.stringify(jsonReq),
        success: function (data) {
            console.log(data);
            $('#confirmationModal').modal('show');
        },
        error: function (err) {
            document.getElementById('errorMessageContent').innerText = err.responseText;
            $('#errorModal').modal('show');
            console.log(err);
        }
    });
}

function addSlot() {
    const form = document.addSlotForm;
    const jsonReq = {
        dayCode: form.day.value,
        startingHour: form.startingHour.value,
        storeCapacity: form.storeCapacity.value
    }
    $.ajax({
        url: '/api/store/addSlot',
        method: 'POST',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        contentType: 'application/json',
        data: JSON.stringify(jsonReq),
        success: function (data) {
            $('#confirmationModal').modal('show');
        },
        error: function (err) {
            if (err.status == 400) {
                document.getElementById('errorMessageContent').innerText = "Some required fields are missing or bad formatted, please check them and submit the form again.";
                $('#errorModal').modal('show');
                return false;
            }
            console.log(err);
        }
    })
    console.log(form.day.value + " " + form.startingHour.value + " " + form.storeCapacity.value)
}