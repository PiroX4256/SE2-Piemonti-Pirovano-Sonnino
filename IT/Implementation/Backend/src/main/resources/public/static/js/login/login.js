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
            window.location.href = "/";
        },
        error: function (err) {
            if(err.status==401) {
                alert("Invalid username or password. Retry!")
            }
        }
    })
})