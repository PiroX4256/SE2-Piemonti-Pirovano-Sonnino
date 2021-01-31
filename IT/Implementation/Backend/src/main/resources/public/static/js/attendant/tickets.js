$(document).ready(function () {
    if (localStorage.getItem('token') == null) {
        window.location.href = '/';
    }
    $.ajax({
        url: '/api/ticket/getMyStoreUpcomingTickets',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (data) {
            buildBookings(data);
        },
        error: function (err) {
            if(err.status == 403) {
                window.location.href = '/';
            }
        }
    });
});

function buildBookings(data) {
    var bookingsContainer = new Vue({
        el: '#bookingsContainer',
        data: {
            data
        },
        methods: {
            substring: function (str) {
                return str.substr(0, 10);
            },
            voidBooking: function (ticketId) {
                voidTicket(ticketId);
            }
        }
    });
}

function voidTicket(ticketId) {
    var confirmation = confirm("Are you sure to void ticket number " + ticketId + "?");
    if(confirmation) {
        $.ajax({
            url: '/api/ticket/voidUserTicket?ticketId=' + ticketId,
            method: 'GET',
            headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
            success: function (data) {
                alert("Ticket voided successfully!");
                location.reload();
            },
            error: function (err) {
                console.log(err);
            }
        });
    }
}