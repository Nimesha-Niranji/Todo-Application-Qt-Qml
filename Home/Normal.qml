import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "Admin.js" as ADMIN_JS
import "qrc:/Login/Login.js" as LOGIN_JS

Page {
    id: normalPage

    height: 600
    width: 500
    background: null

    property StackView stackViewRef
    property string authToken: ""

    property var todoDetailModel: ({
        id: -1,
        title: "",
        description: "",
        completed: false,
        todo_user: ""
    })

    property var userDetailModel: ({
        id: -1,
        login: "",
        department: "",
        role: "",
        name: ""
    })

    function findItemById(model, id) {
        for (let i = 0; i < model.count; i++) {
            let item = model.get(i);
            if (item.id === id) {
                return item;
            }
        }
        return null;
    }

    function fetchAndFill(url, model) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", url)
        xhr.setRequestHeader("Authorization", "Token " + authToken)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var items = JSON.parse(xhr.responseText)
                    console.log("Received items from " + url + ":", JSON.stringify(items))
                    model.clear()
                    for (var i = 0; i < items.length; i++) {
                        model.append(items[i])
                    }
                } else {
                    console.log("Failed to fetch data from", url, xhr.responseText)
                }
            }
        }
        xhr.send()
    }

    Component.onCompleted: {
        console.log(userRole)
        if (authToken !== "") {
            fetchAndFill("http://127.0.0.1:8000/todo/list/", todoModel)
            fetchAndFill("http://127.0.0.1:8000/todo/user/", userModel)
        }
    }

    Rectangle{
        id: normalBox

        anchors.fill: parent
        height: parent.height
        width: parent.width
        color: "#99C68E"

        ColumnLayout{
            anchors.horizontalCenter: parent.horizontalCenter

            ListModel { id: userModel}
            ListModel { id: todoModel }

            Button {
                id: logoutButton
                text: "Logout"
                anchors.right: normalBox.right
                anchors.top: normalBox.top

                onClicked: {
                    logoutDialog.open()
                }

                Dialog {
                    id: logoutDialog
                    modal: true
                    title: "Confirm Logout"
                    standardButtons: Dialog.Yes | Dialog.Cancel
                    visible: false
                    onAccepted: {
                        LOGIN_JS.logout(authToken, stackViewRef)
                    }
                    onRejected: {
                        // Just close the dialog
                        logoutDialog.close()
                    }

                    contentItem: Text {
                        text: "Are you sure you want to logout?"
                        wrapMode: Text.Wrap
                        padding: 10
                    }
                }
            }

            Label{}

            RowLayout{
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: todoListButton
                    text: "Todo List";
                    font.pixelSize: 15;
                    background: Rectangle {
                        color: "#4CAF50" // Green
                        radius: 6
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: sectionView.currentIndex = 0
                }

                Button {
                    id: addButton
                    text: "Add Todo";
                    font.pixelSize: 15;
                    background: Rectangle {
                        color: "#4CAF50" // Green
                        radius: 6
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: sectionView.currentIndex = 1
                }

                Button {
                    id: userButton
                    text: "All Users";
                    font.pixelSize: 15;
                    background: Rectangle {
                        color: "#4CAF50" // Green
                        radius: 6
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: sectionView.currentIndex = 2
                }


            }

            StackLayout{
                id: sectionView
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    id: aboutTodos
                    color: "lightgreen"
                    width: parent.width*0.85
                    height: parent.height * 0.5
                    //anchors.centerIn: parent

                    Column {
                        anchors.fill: parent
                        spacing: 10
                        padding: 10

                        RowLayout{
                            width: parent.width
                            Text {
                                text: "Todos"
                                font.bold: true
                                font.pointSize: 16
                            }

                            Rectangle {
                                height: 20
                                width: 20
                                color: "green"
                                anchors.right: aboutTodos.right

                                Image {
                                    anchors.fill: parent
                                    source: "qrc:/Image/refresh-icon.png"
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            ADMIN_JS.refreshModel("http://127.0.0.1:8000/todo/list/", todoModel, authToken)
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: todoListRectangle
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: normalBox.width*0.85
                            height: normalBox.height*0.75
                            color: "#9CB071"

                            // ListView to display the todos
                            ListView {
                                width: parent.width
                                height: parent.height
                                //*0.6
                                model: todoModel
                                clip: true
                                delegate: Item {
                                    width: todoListRectangle.width
                                    height: 50
                                    Rectangle {
                                        width: parent.width
                                        height: 50
                                        color: "#9CB071"
                                        border.color: "#254117"
                                        Text {
                                            anchors.centerIn: parent
                                            text: model.title + " - " + model.todo_user
                                            font.pixelSize: 15
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if (!model || model.id === undefined) {
                                                    console.warn("Clicked item has no ID")
                                                    return
                                                }

                                                var xhr = new XMLHttpRequest()
                                                xhr.open("GET", "http://127.0.0.1:8000/todo/" + model.id + "/")
                                                xhr.setRequestHeader("Authorization", "Token " + authToken)
                                                xhr.onreadystatechange = function () {
                                                    if (xhr.readyState === XMLHttpRequest.DONE) {
                                                        if (xhr.status === 200) {
                                                            var data = JSON.parse(xhr.responseText)
                                                            todoDetailModel.id = data.id
                                                            todoDetailModel.title = data.title
                                                            todoDetailModel.description = data.description
                                                            todoDetailModel.completed = data.completed
                                                            todoDetailModel.todo_user = data.todo_user

                                                            //push AFTER data is assigned
                                                            todoStackView.push("qrc:/Home/TodoDetailPage.qml", {
                                                                stackViewRef: todoStackView,

                                                                onDeleteClicked: function(index) {
                                                                    let item = todoModel.get(index);
                                                                    if (item) {
                                                                        let url = "http://127.0.0.1:8000/todo/" + item.id + "/";
                                                                        ADMIN_JS.deleteItem(url, authToken, function() {
                                                                            todoModel.remove(index);
                                                                            console.log("Todo deleted with ID:", item.id);
                                                                            fetchAndFill("http://127.0.0.1:8000/todo/list/", todoModel);
                                                                        });
                                                                    }else {
                                                                        console.log("Item not found at index", index);
                                                                    }
                                                                },

                                                                onUpdateClicked: function(index, newTitle) {
                                                                    let item = todoModel.get(index);
                                                                    let url = "http://127.0.0.1:8000/todo/" + item.id + "/";
                                                                    let updatedData = {
                                                                        title: newTitle,
                                                                        description: item.description,
                                                                        completed: item.completed,
                                                                    };
                                                                    ADMIN_JS.updateItem(url, updatedData, authToken, function() {
                                                                        todoModel.set(index, {
                                                                            id: item.id,
                                                                            title: newTitle,
                                                                            description: item.description,
                                                                            completed: item.completed,
                                                                        });

                                                                        console.log("Todo updated:", item.id);
                                                                    });
                                                                },
                                                                onRefresh: function() {
                                                                    ADMIN_JS.refreshModel("http://127.0.0.1:8000/todo/list/", todoModel, authToken);
                                                                }
                                                            });
                                                        } else {
                                                            console.log("Failed to fetch todo detail:", xhr.responseText)
                                                        }
                                                    }
                                                }
                                                xhr.send()
                                            }
                                        }
                                    }
                                }

                                ScrollBar.vertical: ScrollBar {
                                    policy: ScrollBar.AlwaysOn
                                }

                                onCountChanged: {
                                    // Automatically scroll to the bottom
                                    positionViewAtEnd()
                                }
                            }

                            // StackView to show the todo details page
                            StackView {
                                id: todoStackView
                                anchors.top: parent.top
                                anchors.left: parent.left
                                width: parent.width
                                height: parent.height
                            }
                        }
                    }
                }

                Rectangle{
                    id: addTodos
                    color: "lightgreen"
                    width: parent.width*0.85
                    height: parent.height * 0.5

                    Column{
                        anchors.fill: parent
                        spacing: 10
                        padding: 10

                        RowLayout {
                            Label {
                                text: "Title:"
                                color: "black"
                                font.pixelSize: 15
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Rectangle {
                                Layout.preferredWidth: normalBox.width * 0.5
                                Layout.preferredHeight: normalBox.height * 0.05
                                color: "lightblue"
                                TextField {
                                    id: titleInput
                                    placeholderText: "Enter title"
                                    background: null
                                }
                            }
                        }

                        RowLayout {
                            Label {
                                text: "Description:"
                                color: "black"
                                font.pixelSize: 15
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Rectangle {
                                Layout.preferredWidth: normalBox.width * 0.5
                                Layout.preferredHeight: normalBox.height * 0.05
                                color: "lightblue"
                                TextField {
                                    id: descriptionInput
                                    placeholderText: "Enter description"
                                    background: null
                                }
                            }
                        }

                        RowLayout {
                            Label {
                                text: "Completed:"
                                color: "black"
                                font.pixelSize: 15
                                Layout.alignment: Qt.AlignHCenter
                            }
                            CheckBox {
                                id: completedInput
                            }
                        }

                        Button {
                            id: addTodoButton
                            text: qsTr("Add Todo")
                            Layout.preferredWidth: addTodos.width * 0.3
                            Layout.preferredHeight: addTodos.height * 0.15
                            Layout.alignment: Qt.AlignHCenter

                            contentItem: Text {
                                text: addTodoButton.text
                                color: "black"
                                font.pixelSize: 15
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                Layout.preferredWidth: parent.width
                                Layout.preferredHeight: parent.height
                                opacity: 0.5
                                color: "darkblue"
                                border.color: "black"
                                border.width: 1
                                radius: 2
                            }

                            onClicked: {
                                ADMIN_JS.addTodo()
                            }
                        }

                    }
                }

                Rectangle {
                    id: aboutUsers
                    color: "lightgreen"
                    width: parent.width*0.85
                    height: parent.height * 0.5

                    Column {
                        anchors.fill: parent
                        spacing: 10
                        padding: 10

                        RowLayout{
                            width: parent.width
                            Text {
                                text: "Todo Users"
                                font.bold: true
                                font.pointSize: 16
                            }

                            Rectangle {
                                height: 20
                                width: 20
                                color: "green"
                                anchors.right: aboutUsers.right

                                Image {
                                    anchors.fill: parent
                                    source: "qrc:/Image/refresh-icon.png"
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            ADMIN_JS.refreshModel("http://127.0.0.1:8000/todo/user/", userModel, authToken)
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: userListRectangle
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: normalBox.width*0.85
                            height: normalBox.height*0.75
                            color: "#9CB071"

                            // ListView to display the todos
                            ListView {
                                width: parent.width
                                height: parent.height
                                //*0.6
                                model: userModel
                                clip: true
                                delegate: Item {
                                    width: userListRectangle.width
                                    height: 50
                                    Rectangle {
                                        width: parent.width
                                        height: 50
                                        color: "#9CB071"
                                        border.color: "#254117"
                                        Text {
                                            anchors.centerIn: parent
                                            text: model.name + " - " + model.login_display
                                            font.pixelSize: 15
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if (!model || model.id === undefined) {
                                                    console.warn("Clicked item has no ID")
                                                    return
                                                }

                                                var xhr = new XMLHttpRequest()
                                                xhr.open("GET", "http://127.0.0.1:8000/todo/user/" + model.id + "/")
                                                xhr.setRequestHeader("Authorization", "Token " + authToken)
                                                xhr.onreadystatechange = function () {
                                                    if (xhr.readyState === XMLHttpRequest.DONE) {
                                                        if (xhr.status === 200) {
                                                            var data = JSON.parse(xhr.responseText)
                                                            userDetailModel.id = data.id
                                                            userDetailModel.login = data.login_display
                                                            userDetailModel.department = data.department_display
                                                            userDetailModel.role = data.role_display
                                                            userDetailModel.name = data.name

                                                            // push AFTER data is assigned
                                                            userStackView.push("qrc:/Home/UserDetailPage.qml", { stackViewRef: userStackView })


                                                        } else {
                                                            console.log("Failed to fetch todo detail:", xhr.responseText)
                                                        }
                                                    }
                                                }
                                                xhr.send()
                                            }
                                        }
                                    }
                                }

                                ScrollBar.vertical: ScrollBar {
                                    policy: ScrollBar.AlwaysOn
                                }

                                onCountChanged: {
                                    // Automatically scroll to the bottom
                                    positionViewAtEnd()
                                }
                            }

                            // StackView to show the todo details page
                            StackView {
                                id: userStackView
                                anchors.top: parent.top
                                anchors.left: parent.left
                                width: parent.width
                                height: parent.height
                            }
                        }
                    }
                }
            }
        }

    }

}
