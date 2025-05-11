import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls
import QtQuick.Window
//import QtQuick.Controls.Basic
//import QtQuick.Layouts

Window {
    id: root
    visible: true
    width: 500
    height: 600
    title: qsTr("To Do Application")

    property string userRole: ""
    property string userDepartment: ""
    property string token: ""
    property StackView stackViewRef

    StackView{
        id: stackView
        anchors.fill: parent
        //initialItem: "qrc:/Login/Login.qml"
        initialItem: Component {
            Item {
                Loader {
                    id: loginLoader
                    anchors.fill: parent
                    // source: "qrc:/Register/Register.qml"
                    source: "qrc:/Login/Login.qml"
                    // source: "qrc:/Home/Admin.qml"
                    onLoaded: {
                        loginLoader.item.stackViewRef = stackView
                    }
                }
            }
        }
    }
}
