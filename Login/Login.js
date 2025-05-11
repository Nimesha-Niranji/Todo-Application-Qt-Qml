function login() {

    var xhr = new XMLHttpRequest();
    var url = "http://127.0.0.1:8000/todo/account/login/";

    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/json");

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                token = response.token;
                // var role = response.role;
                userRole = response.role
                userDepartment = response.department
                console.log("Login successful. Token: " + response.token);
                console.log(JSON.stringify(response));

                // Navigate to user page
                if (userRole === "Admin") {
                    stackViewRef.push(Qt.resolvedUrl("qrc:/Home/Admin.qml"), { authToken: token, stackViewRef: stackViewRef });
                } else if (userRole === "Manager") {
                    stackViewRef.push(Qt.resolvedUrl("qrc:/Home/Manager.qml"), { authToken: token, stackViewRef: stackViewRef });
                } else {
                    stackViewRef.push(Qt.resolvedUrl("qrc:/Home/Normal.qml"), { authToken: token, stackViewRef: stackViewRef });
                }

            } else {
                console.log("Login failed: " + xhr.responseText);
                errorPopup.open()
                // Optionally show an error message to the user
            }
        }
    }

    var data = {
        username: nameInput.text,
        password: passwordInput.text
    };

    xhr.send(JSON.stringify(data));
}

function logout(token, stackViewRef) {
    var xhr = new XMLHttpRequest();
    var url = "http://127.0.0.1:8000/account/logout/";

    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.setRequestHeader("Authorization", "Token " + token);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                console.log("Logout successful");
                // Clear user data (optional)
                token = "";
                userRole = "";
                userDepartment = "";

                stackViewRef.clear();
                stackViewRef.push(Qt.resolvedUrl("qrc:/Login/Login.qml"), {
                    stackViewRef: stackViewRef
                });


            } else {
                console.log("Logout failed: " + xhr.responseText);
            }
        }
    };

    xhr.send();
}

