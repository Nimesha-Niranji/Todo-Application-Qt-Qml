function admin() {

    if (loginInput.currentIndex < 0 || departmentInput.currentIndex < 0 ||
        roleInput.currentIndex < 0 || nameInput.text.trim() === "") {
        console.log("All fields must be selected/filled.")
        messageBox.text = "All fields must be selected/filled.";
        messageBox.open();
        return
    }

    var xhr = new XMLHttpRequest()
    xhr.open("POST", "http://127.0.0.1:8000/todo/user/")
    xhr.setRequestHeader("Content-Type", "application/json")
    xhr.setRequestHeader("Authorization", "Token " + authToken)

    var userData = {
        login: loginInput.currentValue,
        department: departmentInput.currentValue,
        role: roleInput.currentValue,
        name: nameInput.text
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 201 || xhr.status === 200) {
                console.log("User added successfully:", xhr.responseText)
                messageBox.text = "User added successfully.";
                messageBox.open();
                nameInput.text = ""
                ADMIN_JS.refreshModel("http://127.0.0.1:8000/todo/user/unregistered/", loginModel, authToken)
            } else {
                console.log("Failed to add user:", xhr.responseText)
            }
        }
    }

    xhr.send(JSON.stringify(userData))  // ✅ fixed here
}


function addItem(value, model, url, token, refreshCallback, fieldName) {
    if (!value || value.trim() === "")
        return console.log("Value is empty");

    // Check if item already exists based on dynamic field
    for (var i = 0; i < model.count; i++) {
        var item = model.get(i);
        if (item[fieldName] && item[fieldName].toLowerCase() === value.toLowerCase()) {
            console.log("Item already exists:", value);
            messageBox.text = "Item already exists.";
            messageBox.open();
            return;
        }
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", url);
    xhr.setRequestHeader("Authorization", "Token " + token);
    xhr.setRequestHeader("Content-Type", "application/json");

    var payload = {};
    payload[fieldName] = value;

    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 201 || xhr.status === 200) {
                console.log("Item added:", value);
                if (refreshCallback)
                    refreshCallback();
            } else {
                console.log("Failed to add item:", xhr.responseText);
            }
        }
    };

    xhr.send(JSON.stringify(payload));
}


function refreshModel(url, model, token) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url);
    xhr.setRequestHeader("Authorization", "Token " + token);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var items = JSON.parse(xhr.responseText);
                model.clear();
                for (var i = 0; i < items.length; i++) {
                    model.append(items[i]);
                }
            } else {
                console.log("Failed to refresh model from", url, xhr.responseText);
            }
        }
    };
    xhr.send();
}

function deleteItem(url, authToken, successCallback) {
    var xhr = new XMLHttpRequest();
    xhr.open("DELETE", url, true);
    xhr.setRequestHeader("Authorization", "Token " + authToken);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 204) { // No content for successful DELETE
                console.log("Item deleted successfully");
                messageBox.text = "Item deleted successfully.";
                messageBox.open();
                if (typeof successCallback === "function") {
                    successCallback();
                }
            } else {
                console.log("Failed to delete item:", xhr.responseText);
            }
        }
    };
    xhr.send();
}

// Function to handle PATCH request for updating
function updateItem(url, data, authToken, successCallback) {
    var xhr = new XMLHttpRequest();
    xhr.open("PUT", url, true);
    xhr.setRequestHeader("Authorization", "Token " + authToken);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                console.log("Item updated successfully");
                messageBox.text = "Item updated successfully.";
                messageBox.open();
                if (typeof successCallback === "function") {
                    successCallback();
                }
            } else {
                console.log("Failed to update item:", xhr.responseText);
            }
        }
    };
    xhr.send(JSON.stringify(data));
}

function addTodo() {
    if (titleInput.text.trim() === "" || descriptionInput.text.trim() === "") {
        console.log("Title and Description must be filled.")
        messageBox.text = "Title and Description must be filled.";
        messageBox.open();
        return
    }

    var xhr = new XMLHttpRequest()
    xhr.open("POST", "http://127.0.0.1:8000/todo/list/")
    xhr.setRequestHeader("Content-Type", "application/json")
    xhr.setRequestHeader("Authorization", "Token " + authToken)

    var todoData = {
        title: titleInput.text,
        description: descriptionInput.text,
        completed: completedInput.checked
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 201 || xhr.status === 200) {
                console.log("Todo added successfully:", xhr.responseText)
                messageBox.text = "Todo added successfully.";
                messageBox.open();
                titleInput.text = ""
                descriptionInput.text = ""
                completedInput.checked = false
                // Optional: Refresh model if you show todos somewhere
                // ADMIN_JS.refreshModel("http://127.0.0.1:8000/todo/todo/", todoModel, authToken)
            } else {
                console.log("Failed to add todo:", xhr.responseText)
            }
        }
    }

    xhr.send(JSON.stringify(todoData))
}




