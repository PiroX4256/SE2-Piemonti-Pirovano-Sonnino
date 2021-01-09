function getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
}

if(getCookie("social-authentication")!=null) {
    localStorage.setItem('token', getCookie("social-authentication"));
    window.location.href = "/dashboard";
}
