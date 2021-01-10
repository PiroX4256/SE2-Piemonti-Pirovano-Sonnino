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

        }
    });
}