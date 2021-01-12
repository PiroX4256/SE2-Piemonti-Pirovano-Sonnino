var signupContainer = new Vue({
    el: '#signupContainer',
    data: {
        manager: false,
        attendant: false,
        key: "",
    },
    methods: {
        toggleAttendant() {
            this.attendant = true;
            this.manager = false;
        },
        toggleStoreManager() {
            this.attendant = false;
            this.manager = true;
        },
    }
});

function submitForm() {
    var form = document.signUpForm;
    let role, jsonReq;
    if(signupContainer.manager) {
        role = "MANAGER";
        jsonReq = {username: form.username.value, password: form.password.value, name: form.name.value, surname: form.surname.value, role: role}
    } else if(signupContainer.attendant) {
        role = "ATTENDANT";
        jsonReq = {username: form.username.value, password: form.password.value, name: form.name.value, surname: form.surname.value, role: role, storeId: form.storeId.value}
    } else {
        role = "USER";
        jsonReq = {username: form.username.value, password: form.password.value, role: role}
    }
    if(form.password.value != form.confirmPassword.value) {
        alert("Passwords do not match!");
        return;
    }
    $.ajax({
        url: '/api/auth/signup',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(jsonReq),
        success: function (data) {
            alert("Registration successful! You will be now redirected to login page.");
            window.location.href = '/login';
        },
        error: function (err) {
            if(err.status == 400) {
                alert("Error during the sign up process. The profile with the provided username already exists in our systems.");
            } else {
                alert("Error during the sign up process. Please check all the fields and try again. Error: ");
            }
            console.log(err);
        }
    });
}
