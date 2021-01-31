$(document).ready(function () {
    if (localStorage.getItem('token') == null) {
        window.location.href = '/';
    }
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
                    getTicketType(type) {
                        if(type=="SCHEDULED") {
                            return "ui green label";
                        }
                        else if(type=="USED") {
                            return "ui label";
                        }
                        else if(type=="VOID") {
                            return "ui red label"
                        }
                    },
                    substring: function (str) {
                        return str.substr(0, 10);
                    },
                    voidTicket: function (ticketId) {
                        voidTicket(ticketId);
                    },
                    printQrCode: function (uuid, date, time) {
                        if(document.getElementById('qrCode')!=null) {
                            document.getElementById('qrCode').innerHTML = "";
                        }
                        document.getElementById('dateLabel').innerText = date;
                        document.getElementById('timeLabel').innerText = time;
                        var qrCode = new QRCode(document.getElementById('qrCode'), {
                            text: uuid,
                            width: 128,
                            height: 128
                        });
                        $('.ui.modal')
                            .modal('show')
                        ;
                        //document.getElementById('segmentContainer').style.visibility = "visible";
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

function voidTicket(ticketId) {
    var confirmation = confirm("Are you sure to void ticket number " + ticketId + "?");
    if (confirmation) {
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