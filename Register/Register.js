function register() {

    if (
        emailInput.text === "" ||
        nameInput.text === "" ||
        password1Input.text === "" ||
        password2Input.text === ""
    ) {
        console.log("All fields must be filled");
        return;
    }

    if (password1Input.text !== password2Input.text) {
        console.log("Passwords do not match");
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "http://127.0.0.1:8000/account/register/");
    xhr.setRequestHeader("Content-Type", "application/json");

    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 201) {
                var response = JSON.parse(xhr.responseText);
                if (response.token) {
                    console.log("Registration successful. Token: " + response.token);
                    // Redirect to login or user page
                    stackViewRef.push("qrc:/Home/Home.qml");
                } else {
                    console.log("Registration failed: " + JSON.stringify(response));
                }
            } else {
                console.log("Server error: " + xhr.status);
                console.log("Error response: " + xhr.responseText);
            }
        }
    }

    var data = {
        email: emailInput.text,
        username: nameInput.text,
        password: password1Input.text,
        password2: password2Input.text
    };

    xhr.send(JSON.stringify(data));
}
