import QtQuick 2.15
import QtQuick.Controls


Page {
    id: userDetailPage
    title: "User Details"
    property StackView stackViewRef
    property var onRefresh: null
    height: 600*0.75
    width: 500*0.85

    background: Rectangle{
        color: "#85BB65"
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
            text: "Name: " + userDetailModel.name
            font.pixelSize: 18
        }

        Text {
            text: "Department: " + userDetailModel.department
            wrapMode: Text.WordWrap
        }

        Text {
            text: "Role: " + userDetailModel.role
        }

        Text {
            text: "Username: " + userDetailModel.login
        }
    }
}

