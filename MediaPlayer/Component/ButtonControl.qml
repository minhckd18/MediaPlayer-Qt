import QtQuick 2.0

MouseArea {
    property string icon_default: ""
    property string icon_pressed: ""
    implicitWidth: img.width
    implicitHeight: img.height
    Image {
        id: img
        source: parent.pressed ? parent.icon_pressed : parent.icon_default
    }
}
