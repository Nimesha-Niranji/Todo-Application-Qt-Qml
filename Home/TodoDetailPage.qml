//TodoDetailPage.qml
import QtQuick 2.15
import QtQuick.Controls
import "Admin.js" as ADMIN_JS

Page {
    id: todoDetailPage
    title: "Todo Details"
    property StackView stackViewRef
    property var onRefresh: null
    property var onDeleteClicked: null
    property var onUpdateClicked: null

    height: 600*0.75
    width: 500*0.85

    background: Rectangle{
        color: "#85BB65"
    }

    Dialog {
        id: editDialog
        title: "Edit Todo"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        property alias titleField: titleField
        property alias descField: descField
        property alias completedState: completedState

        contentItem: Column {
            spacing: 10
            padding: 10

            TextField {
                id: titleField
                placeholderText: "Title"
            }

            TextArea {
                id: descField
                placeholderText: "Description"
                wrapMode: Text.WordWrap
                height: 100
            }

            CheckBox {
                id: completedState
                text: "Completed"
            }
        }

        onAccepted: {
            const url = "http://localhost:8000/todo/" + todoDetailModel.id + "/"
            const data = {
                title: titleField.text,
                description: descField.text,
                completed: completedState.checked,
                //todo_user: todoDetailModel.todo_user  // must include if your serializer requires it
            }

            ADMIN_JS.updateItem(url, data, authToken, function() {
                if (typeof onRefresh === "function") onRefresh()
                if (stackViewRef) stackViewRef.clear()
            })


        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 10

        Button {
            text: "Back"
            onClicked: {
                if (stackViewRef) {
                    stackViewRef.clear()

                    //stackViewRef.pop(null)
                } else {
                    console.warn("stackViewRef is not set")
                }
            }
        }


        Text {
            text: "Title: " + todoDetailModel.title
            font.pixelSize: 18
        }

        Text {
            text: "Description: " + todoDetailModel.description
            wrapMode: Text.WordWrap
        }

        Text {
            text: "User: " + todoDetailModel.todo_user
        }

        Text {
            text: "Completed: " + (todoDetailModel.completed ? "Yes" : "No")
        }

        Row {
            spacing: 20

            Button {
                id: deleteButton
                text: "Delete"

                onClicked: {
                    logoutDialog.open()
                }

                Dialog {
                    id: logoutDialog
                    modal: true
                    title: "Confirm Delete"
                    standardButtons: Dialog.Yes | Dialog.Cancel
                    visible: false
                    onAccepted: {
                        const url = "http://localhost:8000/todo/" + todoDetailModel.id + "/"
                        ADMIN_JS.deleteItem(url, authToken, function() {
                            if (typeof onRefresh === "function") onRefresh()
                            if (stackViewRef) stackViewRef.clear()
                        })
                        todoDetailPage.deleteItem(index)
                    }
                    onRejected: {
                        // Just close the dialog
                        logoutDialog.close()
                    }

                    contentItem: Text {
                        text: "Are you sure you want to delete?"
                        wrapMode: Text.Wrap
                        padding: 10
                    }
                }
            }


            Button {
                text: "Edit"
                onClicked: {
                    editDialog.titleField.text = todoDetailModel.title
                    editDialog.descField.text = todoDetailModel.description
                    editDialog.completedState.checked = todoDetailModel.completed
                    editDialog.open()
                }
            }
        }
    }

    function deleteItem(index) {
        if (typeof onDeleteClicked === "function") {
            onDeleteClicked(index);
        } else {
            console.warn("onDeleteClicked is not a function");
        }
    }


    function updateItem(index, newValue) {
        if (typeof onUpdateClicked === "function") {
            onUpdateClicked(index, newValue);
        } else {
            console.warn("onUpdateClicked is not a function");
        }
    }


}

