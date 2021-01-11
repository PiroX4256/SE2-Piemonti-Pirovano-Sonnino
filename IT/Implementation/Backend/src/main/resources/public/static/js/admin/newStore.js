function editStoreInformation() {
    const form = document.storeForm;
    for (var i = 0; i < form.elements.length; i++) {
        if (form.elements[i].value === '' && form.elements[i].hasAttribute('required')) {
            document.getElementById('errorMessageContent').innerText = "Some required fields are missing, please check them and submit the form again.";
            $('#errorModal').modal('show');
            return false;
        }
    }
    const jsonReq = {
        id: form.id.value,
        name: form.name.value,
        chain: form.chain.value,
        address: form.address.value,
        city: form.city.value,
        cap: form.cap.value,
        longitude: form.longitude.value,
        latitude: form.latitude.value
    };
    console.log(jsonReq);
    $.ajax({
        url: '/api/store/create',
        method: 'POST',
        headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
        contentType: 'application/json',
        data: JSON.stringify(jsonReq),
        success: function (data) {
            console.log(data);
            $('#confirmationModal').modal('show');
        },
        error: function (err) {
            document.getElementById('errorMessageContent').innerText = err.responseText;
            $('#errorModal').modal('show');
            console.log(err);
        }
    });
}