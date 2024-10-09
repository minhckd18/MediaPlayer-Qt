import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.8
import "Component"

Window {
    id: root
    visible: true
    width: 1920
    height: 1080
    visibility: "FullScreen"
    title: qsTr("Media Player")

    // FilterModel
    ListModel {
        id: filteredModel
    }

    // MediaPlayer
    MediaPlayer{
        id: player
        volume: 0.5
        property bool shuffer: false

        onPlaybackStateChanged: {
            if (playbackState == MediaPlayer.StoppedState && position == duration){
                if (player.shuffer) {
                    player.loops = 1
                    var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                    while (newIndex == mediaPlaylist.currentIndex) {
                        newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                    }
                    mediaPlaylist.currentIndex = newIndex
                } else if(mediaPlaylist.currentIndex < mediaPlaylist.count - 1) {
                    mediaPlaylist.currentIndex = mediaPlaylist.currentIndex + 1;
                } else {
                    // do nothing
                }
            }
        }
        autoPlay: true
    }

    // Backgroud of Application
    Image {
        id: backgroud
        anchors.fill: parent
        source: "qrc:/Image/background.png"
    }

    // Header
    Image {
        id: headerItem
        source: "qrc:/Image/title.png"
        Text {
            id: headerTitleText
            text: qsTr("Media Player")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }

    // Playlist
    Image {
        id: playList_bg
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        source: "qrc:/Image/playlist.png"
        opacity: 0.2
    }

    // Search Overlay - hide by default
    SearchOverlay {
        id: searchOverlay
        mainAppModel: appModel
        mainFilteredModel: filteredModel
        mainMediaPlaylist: mediaPlaylist
    }

    ListView {
        id: mediaPlaylist
        anchors.fill: playList_bg
        model: appModel
        clip: true
        spacing: 2
        currentIndex: 0
        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            Image {
                id: playlistItem
                width: 675
                height: 193
                source: "qrc:/Image/playlist.png"
                opacity: 0.5
            }
            Text {
                text: title
                anchors.fill: parent
                anchors.leftMargin: 70
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 32
            }
            onClicked: {
                mediaPlaylist.currentIndex = index
            }

            onPressed: {
                playlistItem.source = "qrc:/Image/hold.png"
            }
            onReleased: {
                playlistItem.source = "qrc:/Image/playlist.png"
            }
        }
        highlight: Image {
            source: "qrc:/Image/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/Image/playing.png"
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
        onCurrentItemChanged: {
            player.stop()
            player.source = mediaPlaylist.currentItem.myData.source;
        }
    }

    // Media Info
    Text {
        id: audioTitle
        anchors.top: headerItem.bottom
        anchors.topMargin: 20
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 20
        text: mediaPlaylist.currentItem.myData.title;
        color: "white"
        font.pixelSize: 36
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }

    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 20
        text: mediaPlaylist.currentItem.myData.singer;
        color: "white"
        font.pixelSize: 32
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }

    Image {
        id: audioCountSymbol
        anchors.top: headerItem.bottom
        anchors.topMargin: 23
        anchors.right: parent.right
        anchors.rightMargin: 20
        source: "qrc:/Image/music.png"
    }

    Text {
        id: audioCountText
        anchors.top: headerItem.bottom
        anchors.topMargin: 20
        anchors.right: audioCountSymbol.left
        anchors.rightMargin: 10
        text: mediaPlaylist.count;
        color: "white"
        font.pixelSize: 36
    }

    Image {
        id: searchSymbol
        anchors.top: audioCountSymbol.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        width: 38
        fillMode: Image.PreserveAspectFit
        source: "qrc:/Image/search_icon.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                searchOverlay.visible = true;
                searchOverlay.z = 1;
            }
        }
    }

    Component {
        id: appDelegate
        Item {
            width: 400; height: 400
            scale: PathView.iconScale

            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                y: 20; anchors.horizontalCenter: parent.horizontalCenter
                source: model.icon
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    album_art_view.currentIndex = index
                }
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 50
        anchors.top: headerItem.bottom
        anchors.topMargin: 300
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        pathItemCount: 3
        focus: true
        currentIndex: mediaPlaylist.currentIndex
        model: appModel
        delegate: appDelegate
        path: Path {
            startX: 10
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 550; y: 50 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 1100; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        onCurrentIndexChanged: {
            mediaPlaylist.currentIndex = album_art_view.currentIndex
        }
    }

    //Progress
    function str_pad_left(string,pad,length) {
        return (new Array(length+1).join(pad)+string).slice(-length);
    }

    function getTime(time){
        time = time/1000
        var minutes = Math.floor(time / 60);
        var seconds = Math.floor(time - minutes * 60);

        return str_pad_left(minutes,'0',2)+':'+str_pad_left(seconds,'0',2);
    }

    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 120
        text: getTime(player.position)
        color: "white"
        font.pixelSize: 24
    }

    Slider{
        id: progressBar
        width: 816
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 245
        anchors.left: currentTime.right
        anchors.leftMargin: 20
        from: 0
        to: player.duration
        value: player.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: progressBar.availableWidth
            height: implicitHeight
            radius: 2
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: 2
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "qrc:/Image/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/Image/center_point.png"
            }
        }
        onMoved: {
            if (player.seekable){
                player.seek(progressBar.value);
            }
        }
    }

    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: progressBar.right
        anchors.leftMargin: 20
        text: root.getTime(player.duration)
        color: "white"
        font.pixelSize: 24
    }

    //Media control
    SwitchButton {
        id: shuffer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 120
        icon_off: "qrc:/Image/shuffle.png"
        icon_on: "qrc:/Image/shuffle-1.png"
        status: player.shuffer
        onClicked: {
            if (!player.shuffer) {
                player.shuffer = true
            } else {
                player.shuffer = false
            }
        }
    }

    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: shuffer.right
        anchors.leftMargin: 220
        icon_default: "qrc:/Image/prev.png"
        icon_pressed: "qrc:/Image/hold-prev.png"
        //icon_released: "qrc:/Image/prev.png"
        onClicked: {
            if (mediaPlaylist.currentIndex > 0) {
                mediaPlaylist.currentIndex--
            }
        }
    }

    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.left: prev.right
        icon_default: player.playbackState == MediaPlayer.PlayingState ?  "qrc:/Image/pause.png" : "qrc:/Image/play.png"
        icon_pressed: player.playbackState == MediaPlayer.PlayingState ?  "qrc:/Image/hold-pause.png" : "qrc:/Image/hold-play.png"
        onClicked: {
            if (player.playbackState == MediaPlayer.PlayingState) {
                player.pause()
            }
            else {
                player.play()
            }
        }
    }

    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: play.right
        icon_default: "qrc:/Image/next.png"
        icon_pressed: "qrc:/Image/hold-next.png"
        onClicked: {
            if (player.shuffer) {
                var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                while (newIndex == mediaPlaylist.currentIndex) {
                    newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                }
                mediaPlaylist.currentIndex = newIndex
            }
            else if(mediaPlaylist.currentIndex < mediaPlaylist.count - 1 && !player.shuffer) {
                mediaPlaylist.currentIndex = mediaPlaylist.currentIndex + 1;
            }
        }
    }

    SwitchButton {
        id: repeater
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.right: totalTime.right
        icon_on: "qrc:/Image/repeat1_hold.png"
        icon_off: "qrc:/Image/repeat.png"
        status: 0
        onClicked: {
            console.log("Before: loops = " + player.loops);
            if (player.loops != MediaPlayer.Infinite) {
                player.loops = MediaPlayer.Infinite;
            } else {
                player.loops = 1;
            }
        }
    }
}
