import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Window
import "Login.js" as JS

Page{

    id: loginPage
    height: 600
    width: 500
    background: null
    property StackView stackViewRef


    Rectangle{
        id: loginBox
        anchors.centerIn: parent

        height: parent.height*0.5
        width: parent.width*0.6
        border.color: "black"
        radius: height/24
        color: "lightgreen"

        ColumnLayout{
            anchors.fill: parent

            Label{
                id: nameTextBox
                topPadding: 6
                text: "Username:"
                color: "black"
                font.pixelSize: 18
                Layout.preferredHeight: parent.height * 0.05
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                Layout.preferredWidth: parent.width * 0.8
                Layout.preferredHeight: parent.height * 0.12
                color: "green"
                anchors.horizontalCenter: parent.horizontalCenter

                TextField{
                    id: nameInput
                    placeholderText: "Enter your Username"
                    background: null
                    anchors.verticalCenter: parent.verticalCenter
                    //onAccepted: textLabel.text = "Weather for " + textfield.text
                }
            }

            Label{
                id: passwordText
                topPadding: 6
                text: "Password:"
                color: "black"
                font.pixelSize: 18
                Layout.preferredHeight: parent.height * 0.05
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                Layout.preferredWidth: parent.width * 0.8
                Layout.preferredHeight: parent.height * 0.12
                color: "green"
                anchors.horizontalCenter: parent.horizontalCenter

                TextField{
                    id: passwordInput
                    placeholderText: "Enter your Password"
                    background: null
                    anchors.verticalCenter: parent.verticalCenter
                    //onAccepted: textLabel.text = "Weather for " + textfield.text
                }
            }

            Button{
                id: loginButton
                text: qsTr("Login")

                Layout.preferredWidth: parent.width * 0.3
                Layout.preferredHeight: parent.height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter

                contentItem: Text{
                    text: loginButton.text
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
                    JS.login()
                }

            }

            Label{
                id: orText
                //topPadding: 0.02
                text: "or"
                color: "black"
                font.pixelSize: 13
                Layout.preferredHeight: parent.height * 0.05
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button{
                id: registerButton
                text: qsTr("Register")
                //bottomPadding: 18
                Layout.preferredWidth: parent.width * 0.3
                Layout.preferredHeight: parent.height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter

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
                    stackViewRef.push("qrc:/Register/Register.qml", { stackViewRef: stackViewRef })
                }

            }
        }
    }

    Popup{
        id:errorPopup
        width: parent.width*0.5
        height: parent.height*0.3
        anchors.centerIn: parent

        background: Rectangle {
            color: "pink"
            border.color: "black"
            radius: 10
        }

        Label{
            text: "Error login fail"
            font.pixelSize: 10
            anchors.centerIn: parent

        }
    }
}
