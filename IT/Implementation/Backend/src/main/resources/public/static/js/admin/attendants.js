$(document).ready(function () {
    $.ajax({
        url: '/api/store/getMyAttendants',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (data) {
            buildAttendantsContainer(data);
        }
    });
});

function buildAttendantsContainer(data) {
    var attendantsContainer = new Vue({
        el: '#attendantsContainer',
        data: {
            data
        },
        methods: {
            fireAttendant(attendantId) {
                var confirmation = confirm("Are you sure to delete the attendant withe the id " + attendantId);
                if (confirmation) {
                    $.ajax({
                        url: '/api/store/fireAttendant?attendantId=' + attendantId,
                        method: 'GET',
                        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
                        success: function (data) {
                            alert("Success!");
                            location.reload();
                        },
                        error: function (err) {
                            console.log(err);
                        }
                    });
                }
            }
        }
    });
}