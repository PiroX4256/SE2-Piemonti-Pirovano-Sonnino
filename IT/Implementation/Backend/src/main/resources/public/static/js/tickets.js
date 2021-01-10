$(document).ready(function () {
    $.ajax({
        url: '/api/ticket/getMyTickets',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (tickets) {
            console.log(tickets);
            var myTickets = new Vue({
                el: '#ticketsContainer',
                data: {
                    tickets,
                },
                methods: {
                    substring: function (str) {
                        return str.substr(0, 10);
                    },
                    voidTicket: function (ticketId) {
                        voidTicket(ticketId);
                    }
                }
            });
        },
        error: function (err) {
            console.log(err);
        }
    });
});

function voidTicket(ticketId) {
    var confirmation = confirm("Are you sure to void ticket number " + ticketId + "?");
    if(confirmation) {
        $.ajax({
            url: '/api/ticket/voidTicket?ticketId=' + ticketId,
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