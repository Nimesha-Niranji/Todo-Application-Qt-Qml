// ListAddSection.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    id: root
    property alias model: listView.model
    property string title: "Item"
    property string placeholder: "New Item"
    property var onAddClicked: null
    property var onRefresh: null
    property var onDeleteClicked: null
    property var onUpdateClicked: null


    spacing: 8

    RowLayout {
        spacing: 5

        TextField {
            id: inputField
            placeholderText: root.placeholder
            Layout.fillWidth: true
        }

        Button {
            text: "Add"
            onClicked: {
                if (inputField.text !== "") {
                    if (root.onAddClicked) {
                        root.onAddClicked(inputField.text)
                        inputField.text = ""
                    }
                }
            }
        }

        Rectangle {
            height: 20
            width: 20
            color: "green"

            Image {
                anchors.fill: parent
                source: "qrc:/Image/refresh-icon.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.onRefresh)
                            root.onRefresh()
                    }
                }
            }
        }
    }

    // ListView {
    //     id: listView
    //     width: 180
    //     height: 200
    //     delegate: Text {
    //         //required property string name
    //         //text: name
    //         text: model.name || model.role
    //     }
    // }

    Dialog {
        id: editDialog
        title: "Edit Item"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        // Change size
        implicitWidth: 300
        implicitHeight: 150

        // Change background
        background: Rectangle {
            color: "#f0f0f0"   // light gray or any color you want
            radius: 10
        }

        property int editIndex: -1

        contentItem: Rectangle {
            //id: editField
            Layout.preferredWidth: 300
            Layout.preferredHeight: 200
            color: "pink"
            anchors.horizontalCenter: parent.horizontalCenter

            TextField{
                id: editField
                placeholderText: " "
                background: null
                selectByMouse: true
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
                //onAccepted: textLabel.text = "Weather for " + textfield.text
            }
        }

        onAccepted: {
            if (editField.text.trim() !== "" && editIndex !== -1) {
                root.updateItem(editIndex, editField.text)
            }
        }
    }


    ListView {
        id: listView
        width: 180
        height: 200

        delegate: RowLayout {
            width: listView.width
            spacing: 20

            Text {
                text: model.name || model.role
                font.pixelSize: 16
                Layout.fillWidth: true
            }

            Button {
                height: 70
                width: 70
                background: null
                onClicked: function() {
                    editDialog.editIndex = index;
                    editField.text = model.name || model.role;
                    editDialog.open();
                }
                Image {
                    anchors.fill: parent
                    source: "qrc:/Image/update.png"
                    fillMode: Image.PreserveAspectFit
                }
            }

            Button {
                height: 70
                width: 70
                background: null
                onClicked: function() {
                    listAddSection.deleteItem(index)
                }

                Image {

                    anchors.fill: parent
                    source: "qrc:/Image/delete.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }

    // Function to delete an item
    function deleteItem(index) {
        if (typeof root.onDeleteClicked === "function") {
            root.onDeleteClicked(index)
        }
    }


    // Function to update an item
    function updateItem(index, newValue) {
        if (typeof root.onUpdateClicked === "function") {
            root.onUpdateClicked(index, newValue)
        }
    }

}
