var headers;
if (localStorage.getItem('token') != null) {
    headers = {'Authorization': 'Bearer ' + localStorage.getItem('token')};
}
$.ajax({
    url: '/api/store/getAllStores',
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

function storeCall(stores) {
    console.log(stores);
    var storeContainer = new Vue({
        el: "#storeContainer",
        data: {
            stores
        }
    });
}