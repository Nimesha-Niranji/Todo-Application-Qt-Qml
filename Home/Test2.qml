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
                        if (deptName === "") {
                            console.log("Department name is empty")
                            return
                        }

                        // Check if department already exists in the model
                        for (var i = 0; i < departmentModel.count; i++) {
                            if (departmentModel.get(i).name.toLowerCase() === deptName.toLowerCase()) {
                                console.log("Department already exists:", deptName)
                                return
                            }
                        }

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
                                        Qt.callLater(function() {
                                            fetchAndFill("http://127.0.0.1:8000/todo/department/", departmentModel)
                                        })
                                        //fetchAndFill("http://127.0.0.1:8000/todo/department/", departmentModel)
                                    } else {
                                        console.log("Failed to add department:", xhr.responseText)
                                    }
                                }
                            }
                            xhr.send(JSON.stringify({ name: deptName }))
                        }
                    }
                }

                Rectangle{
                    height: 20
                    width: 20
                    color: "green"
                    Image {
                        anchors.fill: parent
                        source: "qrc:/Image/refresh-icon.png"  // make sure this exists in your assets
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                fetchAndFill("http://127.0.0.1:8000/todo/department/", departmentModel)
                            }
                        }
                    }
                }
            }

            ListView {
                width: 180; height: 200

                model: departmentModel
                delegate: Text {
                    required property string name
                    text: name
                }
            }
        }
    }
}
