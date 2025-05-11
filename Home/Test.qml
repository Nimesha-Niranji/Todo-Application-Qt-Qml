import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "Admin.js" as ADMIN_JS
Page {
    id: adminPage
    height: 600
    width: 500
    background: null
    property StackView stackViewRef
    property string authToken: ""

    Component.onCompleted: {
        console.log(userRole);
    }

    Rectangle{
        id: adminBox
        anchors.fill: parent

        height: parent.height
        width: parent.width
        color: "#99C68E"

        ColumnLayout{
            //anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            ListModel { id: loginModel }
            ListModel { id: departmentModel }
            ListModel { id: roleModel }

            Label{}

            RowLayout {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Button { text: "Departments"; onClicked: sectionView.currentIndex = 0 }
                Button { text: "Roles"; onClicked: sectionView.currentIndex = 1 }
                Button { text: "Todo Lists"; onClicked: sectionView.currentIndex = 2 }
                Button { text: "Users"; onClicked: sectionView.currentIndex = 3 }
            }

            StackLayout {
                id: sectionView
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    color: "lightgreen"
                    width: parent.width
                    height: parent.height * 0.5

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 8
                        //padding: 10

                        RowLayout {
                            spacing: 5
                            TextField {
                                id: newDepartmentField
                                placeholderText: "New Department"
                                Layout.fillWidth: true
                            }
                            Button {
                                text: "Add"
                                onClicked: {
                                    var deptName = newDepartmentField.text
                                    if (deptName !== "") {
                                        var xhr = new XMLHttpRequest()
                                        xhr.open("POST", "http://127.0.0.1:8000/todo/department/")
                                        xhr.setRequestHeader("Authorization", "Token " + authToken)
                                        xhr.setRequestHeader("Content-Type", "application/json")
                                        xhr.onreadystatechange = function() {
                                            if (xhr.readyState === XMLHttpRequest.DONE) {
                                                if (xhr.status === 201) {
                                                    console.log("Department added")
                                                    newDepartmentField.text = ""
                                                    fetchAndFill("http://127.0.0.1:8000/todo/department/", departmentModel)
                                                } else {
                                                    console.log("Failed to add department:", xhr.responseText)
                                                }
                                            }
                                        }
                                        xhr.send(JSON.stringify({ name: deptName }))
                                    }
                                }
                            }
                        }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: departmentModel
                            delegate: Rectangle {
                                width: parent.width
                                height: 200
                                color: "#e0ffe0"
                                border.color: "black"

                                Text {
                                    anchors.centerIn: parent
                                    text: model.name
                                    color: "black"
                                }
                            }
                        }
                    }
                }


                Rectangle {
                    color: "lightblue"
                    ListAddSection {
                        title: "Roles"
                        getUrl: "http://127.0.0.1:8000/todo/role/"
                        postDataKey: "role"
                        authToken: authToken
                    }
                }

                Rectangle {
                    color: "lightyellow"
                    ListAddSection {
                        title: "Todo Lists"
                        getUrl: "http://127.0.0.1:8000/todo/todolist/"
                        postDataKey: "title"
                        authToken: authToken
                    }
                }

                Rectangle {
                    color: "lightgray"
                    ColumnLayout {
                        spacing: 8

                        RowLayout {
                            Label { text: "Login:" }
                            ComboBox {
                                id: loginInput
                                model: loginModel
                                textRole: "username"
                                valueRole: "id"
                            }
                        }

                        RowLayout {
                            Label { text: "Department:" }
                            ComboBox {
                                id: departmentInput
                                model: departmentModel
                                textRole: "name"
                                valueRole: "id"
                            }
                        }

                        RowLayout {
                            Label { text: "Role:" }
                            ComboBox {
                                id: roleInput
                                model: roleModel
                                textRole: "role"
                                valueRole: "id"
                            }
                        }

                        RowLayout {
                            Label { text: "Name:" }
                            TextField {
                                id: nameInput
                                placeholderText: "Enter user name"
                            }
                        }

                        Button {
                            text: "Add User"
                            onClicked: ADMIN_JS.admin(authToken)
                        }
                    }
                }
            }


            // Rectangle {
            //     id: departmentBox
            //     height: adminPage.height * 0.3
            //     width: adminPage.width * 0.9
            //     color: "lightgreen"
            //     ColumnLayout {
            //         anchors.fill: parent
            //         spacing: 8
            //         //padding: 10

            //         // Input and Button to add new department
            //         RowLayout {
            //             spacing: 5
            //             TextField {
            //                 id: newDepartmentField
            //                 placeholderText: "New Department"
            //                 Layout.fillWidth: true
            //             }
            //             Button {
            //                 text: "Add"
            //                 onClicked: {
            //                     var deptName = newDepartmentField.text
            //                     if (deptName !== "") {
            //                         var xhr = new XMLHttpRequest()
            //                         xhr.open("POST", "http://127.0.0.1:8000/todo/department/")
            //                         xhr.setRequestHeader("Authorization", "Token " + authToken)
            //                         xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8")
            //                         xhr.onreadystatechange = function() {
            //                             if (xhr.readyState === XMLHttpRequest.DONE) {
            //                                 if (xhr.status === 201) {
            //                                     console.log("Department added")
            //                                     newDepartmentField.text = ""
            //                                     fetchAndFill("http://127.0.0.1:8000/todo/department/", departmentModel)
            //                                 } else {
            //                                     console.log("Failed to add department:", xhr.responseText)
            //                                 }
            //                             }
            //                         }
            //                         xhr.send(JSON.stringify({ name: deptName }))
            //                     }
            //                 }
            //             }
            //         }

            //         // List all departments
            //         ListView {
            //             id: departmentListView
            //             model: departmentModel
            //             delegate: Rectangle {
            //                 width: departmentBox.width
            //                 height: 30
            //                 color: "#c8e6c9"
            //                 border.color: "#2e7d32"
            //                 border.width: 1

            //                 Text {
            //                     anchors.centerIn: parent
            //                     text: model.name
            //                     color: "black"
            //                 }
            //             }
            //         }
            //     }
            // }


            // ListView {
            //     width: 180; height: 200

            //     model: departmentModel
            //     delegate: Text {
            //         required property string name
            //         text: name
            //     }
            // }

            RowLayout{

                Label{
                    id: loginText
                    topPadding: 6
                    text: "Login:"
                    color: "black"
                    font.pixelSize: 15
                    Layout.preferredHeight: adminBox.height * 0.05
                    Layout.alignment: Qt.AlignHCenter
                }
                ComboBox {
                    id: loginInput
                    model: loginModel
                    textRole: "username"
                    valueRole: "id"
                }
            }

            RowLayout{

                Label{
                    id: departmentText
                    topPadding: 6
                    text: "Department:"
                    color: "black"
                    font.pixelSize: 15
                    Layout.preferredHeight: adminBox.height * 0.05
                    Layout.alignment: Qt.AlignHCenter
                }
                ComboBox {
                    id: departmentInput
                    model: departmentModel
                    textRole: "name"
                    valueRole: "id"
                }
            }

            RowLayout{

                Label{
                    id: roleText
                    topPadding: 6
                    text: "Role:"
                    color: "black"
                    font.pixelSize: 15
                    Layout.preferredHeight: adminBox.height * 0.05
                    Layout.alignment: Qt.AlignHCenter
                }

                ComboBox {
                    id: roleInput
                    model: roleModel
                    textRole: "role"
                    valueRole: "id"
                }
            }

            RowLayout{

                Label{
                    id: nameText
                    topPadding: 6
                    text: "Name:"
                    color: "black"
                    font.pixelSize: 15
                    Layout.preferredHeight: adminBox.height * 0.05
                    Layout.alignment: Qt.AlignHCenter
                }
                Rectangle {
                    Layout.preferredWidth: adminBox.width * 0.5
                    Layout.preferredHeight: adminBox.height * 0.05
                    color: "green"
                    Layout.alignment: Qt.AlignHCenter

                    TextField{
                        id: nameInput
                        placeholderText: "Enter"
                        background: null
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Button{
            //     id: addUserButton
            //     text: qsTr("Add User")
            //     Layout.preferredWidth: parent.width * 0.3
            //     Layout.preferredHeight: parent.height * 0.15
            //     Layout.alignment: Qt.AlignHCenter

            //     contentItem: Text{
            //         text: addUserButton.text
            //         color: "black"
            //         font.pixelSize: 15
            //         font.bold: true
            //         horizontalAlignment: Text.AlignHCenter
            //         verticalAlignment: Text.AlignVCenter
            //     }

            //     background: Rectangle {
            //         Layout.preferredWidth: parent.width
            //         Layout.preferredHeight: parent.height
            //         opacity: 0.5
            //         color: "darkgreen"
            //         border.color: "black"
            //         border.width: 1
            //         radius: 2
            //     }

            //     onClicked: {
            //         ADMIN_JS.admin()
            //     }
            // }
        }

        Component.onCompleted: {
            function fetchAndFill(url, model) {
                var xhr = new XMLHttpRequest()
                xhr.open("GET", url)
                xhr.setRequestHeader("Authorization", "Token " + authToken)
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            var items = JSON.parse(xhr.responseText)
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

            if (authToken !== "") {
                fetchAndFill("http://127.0.0.1:8000/todo/user/unregistered/", loginModel)
                fetchAndFill("http://127.0.0.1:8000/todo/department/", departmentModel)
                fetchAndFill("http://127.0.0.1:8000/todo/role/", roleModel)
            }
        }
    }

}
