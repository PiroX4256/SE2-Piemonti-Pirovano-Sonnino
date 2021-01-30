$(document).ready(function () {
    $.ajax({
        url: '/api/auth/userPing',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        error: function (err) {
            if (err.status == 403) {
                window.location.href = '/';
            }
        }
    });
})

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
    document.getElementById('storeContainer').innerHTML =
        "                <tr v-for=\"store in stores\" :key=\"store.id\" style=\"visibility: hidden\" id=\"tableRows\">\n" +
        "                    <td>{{ store.name }}</td>\n" +
        "                    <td>{{ store.chain }}</td>\n" +
        "                    <td>{{ store.address }}</td>\n" +
        "                    <td>{{ store.city }}</td>\n" +
        "                    <td>{{ store.cap }}</td>\n" +
        "                    <td>{{ store.longitude }}, {{ store.latitude }}</td>\n" +
        "                    <td :id=\"store.id\"><button class=\"ui compact primary button\" v-on:click=\"getFirstSlot(store.id)\">Fetch</button></td>\n" +
        "                    <td>\n" +
        "                        <button class=\"ui blue button\" v-on:click=\"asapCall(store.id)\">Choose</button>\n" +
        "                    </td>\n" +
        "                </tr>" +
        "<td v-if='err != \"\"'>{{ err }}</td>";
    if (stores.length == 0) {
        err = "No store found for the specified CAP";
    } else {
        err = "";
    }
    document.getElementById('tableRows').style.visibility = "visible";
    let storeContainer = new Vue({
        el: "#storeContainer",
        data: {
            stores: stores,
            err: err,
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
                        if (slots.length === 0) {
                            document.getElementById(storeId).innerHTML = "";
                            document.getElementById(storeId).innerText = "No slots available today";
                        } else {
                            slots.forEach(function (slot) {
                                console.log(slot.startingHour);
                                if (Date.parse('01/01/2021 ' + slot.startingHour) > Date.parse(dateTime)) {
                                    if (Date.parse('01/01/2021 ' + slot.startingHour) > Date.parse('01/01/2021 ' + document.getElementById(storeId).innerText)) {}
                                    else {
                                        document.getElementById(storeId).innerHTML = "";
                                        document.getElementById(storeId).innerText = slot.startingHour;
                                    }
                                } else {
                                    document.getElementById(storeId).innerHTML = "";
                                    document.getElementById(storeId).innerText = "No slots available today";
                                }
                            })
                        }

                    }
                });
            },
            asapCall(storeId) {
                asap(storeId);
            },
            forceRender() {
                this.componentKey += 1;
            }
        }
    });
    console.log(storeContainer.stores);
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