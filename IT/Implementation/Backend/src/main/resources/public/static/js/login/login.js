$(document).ready(function () {
    if(localStorage.getItem("token") != null) {
        $.ajax({
            url: '/api/auth/checkLogin',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + localStorage.getItem("token")},
            success: function (data) {
                window.location.href = '/dashboard';
            },
            error: function (err) {
                console.log(err);
            }
        });
    }
});

$('#loginForm').on('submit', function () {
    var username = document.getElementById("username").value;
    var password = document.getElementById("password").value;
    $.ajax({
        url: '/api/auth/login',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({username: username, password: password}),
        success: function (data) {
            localStorage.setItem('token', data.token);
            $.ajax({
                url: '/api/auth/me',
                method: 'GET',
                headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
                success: function (data) {
                    console.log(data);
                    localStorage.setItem('username', data);
                    window.location.href = "/dashboard";
                }
            });
        },
        error: function (err) {
            if (err.status == 401) {
                alert("Invalid username or password. Retry!")
            }
        }
    })
});

function submitForm() {
    var form = document.facebookForm;
    form.submit();
}