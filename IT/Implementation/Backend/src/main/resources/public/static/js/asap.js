var headers;
if (localStorage.getItem('token') != null) {
    headers = {'Authorization': 'Bearer ' + localStorage.getItem('token')};
}

$('#searchByCap').on('click', function () {
    var cap = document.getElementById("capContainer").value;
    $.ajax({
        url: '/api/store/getStoresByCap?cap=' + cap,
        method: 'GET',
        headers: headers,
        success: function (data) {
            storeCall(data);
        },
        error: function (err) {
            if (err.status == 401) {
                window.location.href = "/login";
            }
        }
    });
});

function storeCall(stores) {
    document.getElementById('tableRows').style.visibility = "visible";
    var storeContainer = new Vue({
        el: "#storeContainer",
        data: {
            stores
        },
        methods: {
            getFirstSlot(storeId) {
                $.ajax({
                    url: '/api/store/getAvailableSlots?storeId=' + storeId,
                    method: 'GET',
                    headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
                    success: function (slots) {
                        console.log(slots);
                        const date = new Date();
                        const dateTime = '01/01/2021 ' + date.getHours() + ':' + date.getMinutes();
                        if(slots.length === 0) {
                            document.getElementById(storeId).innerHTML = "";
                            document.getElementById(storeId).innerText = "No slots available today";
                        } else {
                            slots.forEach(function (slot, index) {
                                if (Date.parse('01/01/2021 ' + slot.startingHour) > Date.parse(dateTime)) {
                                    document.getElementById(storeId).innerHTML = "";
                                    document.getElementById(storeId).innerText = slot.startingHour;
                                    return;
                                } else if (index === (slots.length - 1)) {
                                    document.getElementById(storeId).innerHTML = "";
                                    document.getElementById(storeId).innerText = "No slots available today";
                                }
                            });
                        }

                    }
                });
            },
            asapCall(storeId) {
                asap(storeId);
            }
        }
    });
}

function asap(storeId) {
    $.ajax({
        url: '/api/ticket/asap?storeId=' + storeId,
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (data) {
            var confirmation = new Vue({
                el: '#confirmationContainer',
                data: {
                    data
                }
            });
            document.getElementById("confirmationMessage").style.visibility = "visible";
        },
        error: function (err) {
            document.getElementById("errorMessageContent").innerText = err.responseText;
            document.getElementById("errorMessage").style.visibility = "visible";
        }
    })
}