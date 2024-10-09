import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: searchOverlay
    visible: false
    anchors.fill: parent

    property var mainAppModel
    property var mainFilteredModel
    property var mainMediaPlaylist

    // Block all interactions with the underlying screen
    MouseArea {
        anchors.fill: parent
        enabled: true
        onClicked: {
            // Do nothing
        }
    }

    // Semi-transparent background
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.8
    }

    // Centered Search Box and Results
    Column {
        id: mainColumn
        anchors.centerIn: parent
        width: parent.width / 2
        spacing: 20

        Rectangle {
            id: searchBox
            width: parent.width
            height: 80
            radius: 40
            color: "#f0f0f0"
            border.color: "#cccccc"
            border.width: 1

            TextField {
                id: searchField
                width: parent.width - 60
                height: parent.height - 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 40
                placeholderText: qsTr("Search song...")
                font.pixelSize: 32
                color: "#333333"
                background: null
                onTextChanged: {
                    searchOverlay.filterAppModel(searchField.text)
                }
            }

            // Clear button
            Rectangle {
                id: clearButton
                width: 80
                height: 40
                radius: 20
                anchors.right: parent.right
                anchors.rightMargin: 40
                anchors.verticalCenter: parent.verticalCenter
                visible: searchField.text.length > 0
                color: "black"

                Text {
                    anchors.centerIn: parent
                    text: "Clear"
                    color: "white"
                    font.pixelSize: 20
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        searchField.text = "";
                        filteredModel.clear();
                    }
                }
            }
        }

        ListView {
            id: filteredListView
            width: 300
            height: 400
            model: filteredModel
            delegate: Rectangle {
                width: mainColumn.width
                height: 80
                border.color: "black"
                border.width: 1

                Text {
                    text: title + " - " + singer
                    anchors.fill: parent
                    anchors.leftMargin: 40
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 32
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        searchOverlay.selectSong(index)
                    }
                }
            }
        }
    }

    // Close button to return to main screen
    Rectangle {
        id: closeButton
        anchors.right: parent.right
        width: 100
        height: 100

        Text {
            anchors.centerIn: parent
            font.pixelSize: 50
            text: "X"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                searchOverlay.visible = false
            }
        }
    }

    function filterAppModel(searchText) {
        mainFilteredModel.clear();
        if (searchText) {
            for (var i = 0; i < mainAppModel.count; i++) {
                var song = mainAppModel.get(i);
                if (song.title.toLowerCase().includes(searchText.toLowerCase()) ||
                        song.singer.toLowerCase().includes(searchText.toLowerCase())) {
                    mainFilteredModel.append(song);
                }
            }
        }
    }

    function selectSong(index) {
        for (var i = 0; i < mainAppModel.count; i++) {
            var song = mainAppModel.get(i);
            if (song.title === mainFilteredModel.get(index).title) {
                mainMediaPlaylist.currentIndex = i;
                searchField.text = "";
                searchOverlay.visible = false;
                break;
            }
        }
    }
}
