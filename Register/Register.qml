import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Window
import "Register.js" as JS

Page {
    id: registerPage
    height: 600
    width: 500
    background: null
    property StackView stackViewRef

    Rectangle{
        id: loginBox
        anchors.centerIn: parent

        height: parent.height*0.65
        width: parent.width*0.6
        border.color: "black"
        radius: height/24
        color: "lightgreen"

        ColumnLayout{
            anchors.fill: parent

            Label{
                id: emailText
                topPadding: 6
                text: "Email:"
                color: "black"
                font.pixelSize: 18
                Layout.preferredHeight: parent.height * 0.05
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.preferredWidth: parent.width * 0.8
                Layout.preferredHeight: parent.height * 0.1
                color: "green"
                Layout.alignment: Qt.AlignHCenter

                TextField{
                    id: emailInput
                    placeholderText: "Enter your Email Address"
                    background: null
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            Label{
                id: nameTextBox
                topPadding: 6
                text: "Username:"
                color: "black"
                font.pixelSize: 18
                Layout.preferredHeight: parent.height * 0.05
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.preferredWidth: parent.width * 0.8
                Layout.preferredHeight: parent.height * 0.1
                color: "green"
                Layout.alignment: Qt.AlignHCenter

                TextField{
                    id: nameInput
                    placeholderText: "Enter your Username"
                    background: null
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Label{
                id: password1Text
                topPadding: 6
                text: "Password:"
                color: "black"
                font.pixelSize: 18
                Layout.preferredHeight: parent.height * 0.05
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.preferredWidth: parent.width * 0.8
                Layout.preferredHeight: parent.height * 0.1
                color: "green"
                Layout.alignment: Qt.AlignHCenter

                TextField{
                    id: password1Input
                    placeholderText: "Enter your Password"
                    background: null
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Label{
                id: password2Text
                topPadding: 6
                text: "Confirm Password:"
                color: "black"
                font.pixelSize: 18
                Layout.preferredHeight: parent.height * 0.05
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.preferredWidth: parent.width * 0.8
                Layout.preferredHeight: parent.height * 0.1
                color: "green"
                Layout.alignment: Qt.AlignHCenter

                TextField{
                    id: password2Input
                    placeholderText: "Enter your Confirme Password"
                    background: null
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Button{
                id: registerButton
                text: qsTr("Register")
                Layout.preferredWidth: parent.width * 0.3
                Layout.preferredHeight: parent.height * 0.1
                Layout.alignment: Qt.AlignHCenter

                contentItem: Text{
                    text: registerButton.text
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
                    color: "darkgreen"
                    border.color: "black"
                    border.width: 1
                    radius: 2
                }

                onClicked: {
                    JS.register()
                }
            }

            Button {
                text: "Back"
                font.pixelSize: 10
                anchors.right: parent.right
                anchors.margins: 10
                //font.pixelSize: 15;
                background: Rectangle {
                    color: "#4CAF50" // Green
                    radius: 6
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    if (stackViewRef) {
                        stackViewRef.pop()
                    } else {
                        console.warn("stackViewRef is not set")
                    }
                }
            }

        }
    }


}
