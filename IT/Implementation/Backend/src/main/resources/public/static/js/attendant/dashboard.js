let storeId;
$(document).ready(function () {
    $.ajax({
        url: '/api/auth/getMyStore',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (data) {
            storeId = data.id;
            $.ajax({
                url: '/api/store/getAvailableSlots?storeId=' + storeId,
                method: 'GET',
                headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
                success: function (slots) {
                    const date = new Date();
                    const dateTime = '01/01/2021 ' + date.getHours() + ':' + date.getMinutes();
                    if (slots.length === 0) {
                        document.getElementById("storeSlot").innerHTML = "";
                        document.getElementById("storeSlot").innerText = "No slots available today";
                    } else {
                        slots.forEach(function (slot, index) {
                            if (Date.parse('01/01/2021 ' + slot.startingHour) > Date.parse(dateTime)) {
                                document.getElementById("storeSlot").innerHTML = "";
                                document.getElementById("storeSlot").innerText = slot.startingHour;
                                return;
                            } else if (index === (slots.length - 1)) {
                                document.getElementById("storeSlot").innerHTML = "";
                                document.getElementById("storeSlot").innerText = "No slots available today";
                            }
                        });
                    }
                }
            });
        },
        error: function (err) {
            if (err.status == 403) {
                window.location.href = '/';
            }
        }
    });
});

var confirmationContainer = new Vue({
    el: '#confirmationContainer',
    data: {
        ticket: null
    },
    methods: {
        generateQRCode() {
            this.$nextTick(() => {
                document.getElementById("qrCodeContent").innerHTML = "";
                new QRCode(document.getElementById("qrCodeContent"), {
                    text: this.ticket.booking.uuid,
                    width: 128,
                    height: 128,
                    colorDark: "#000000",
                    colorLight: "#ffffff",
                    correctLevel: QRCode.CorrectLevel.H
                });
            });
        }
    }
})

function retrieveTicket() {
    var confirmation = confirm("Are you sure?")
    if (confirmation) {
        $.ajax({
            url: '/api/ticket/handOutOnSpot',
            method: 'GET',
            headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
            success: function (data) {
                console.log(data);
                confirmationContainer.ticket = data;
                confirmationContainer.generateQRCode();
            },
            error: function (err) {
                console.log(err);
            }
        });
    }
}

function printElement() {
    $('#confirmationContainer').print();
}