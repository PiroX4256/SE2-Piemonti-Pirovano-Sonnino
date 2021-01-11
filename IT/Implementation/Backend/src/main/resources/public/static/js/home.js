function getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
}

if(getCookie("social-authentication")!=null) {
    localStorage.setItem('token', getCookie("social-authentication"));
    $.ajax({
        url: '/api/auth/me',
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        success: function (data) {
            console.log(data);
            localStorage.setItem('username', data.username);
            window.location.href = "/dashboard";
        }
    });
}
