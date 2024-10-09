# MediaPlayer-Qt

A simple media player built using Qt and QML. The player supports basic features like playing, pausing, next/previous track, and a search functionality. The purpose is to demonstrate the interfacing between Qml with C++.

## Features

- Play/pause, random, repeat, next and previous track controls
- Playlist panel
- Search with title or singer

## Structure

Using the Qt Subdies Template, the project is organized into the following directories (sub-projects):

- **MediaPlayer/**: Contains the main application source code.
- **MediaPlayer/Component/**: Contains QML files for UI components, including `SwitchButton.qml`, `ButtonControl.qml`, and `SearchOverlay.qml`.
- **MediaPlayer/Lib/**: Contains 3rd-party library, just LibTag (built with MinGW) for now.
- **MediaPlayer/Source/**: Contains the classes `Song` and `SongModel`
- **Test**/: Holds unit tests written using the Qt Test framework, including tests for the Cpp classes in `Test_Cpp` and for qml components in `Test_Qml`.

## Setup

1. Clone the repository:
   ```
   git clone https://github.com/minhckd18/MediaPlayer-Qt.git
   ```
2. Open the project in Qt Creator. The project was originally built with Qt MinGW 5.15.0
3. Build and run.

## UML Diagrams

- General class diagram

```mermaid
classDiagram
    class QGuiApplication
    class QQmlApplicationEngine
    class QAbstractListModel
    class QObject

    class Song {
        +QString title
        +QString singer
        +QString icon
        +QString source
        +QString title() const
        +QString singer() const
        +QString icon() const
        +QString source() const
    }

    class SongModel {
        -QList<Song*> m_songs
        +enum SongRoles
        +void addSong(Song *song)
        +int rowCount(const QModelIndex &parent) const
        +QVariant data(const QModelIndex &index, int role) const
        +int count() const
        +QVariantMap get(int index) const
        +void loadSongsFromDirectory(const QString &path)
        +QHash<int, QByteArray> roleNames() const
    }

    class Window {
        +MediaPlayer player
        +ListModel filteredModel
        +ListView mediaPlaylist
        +PathView album_art_view
    }

    QObject <|-- Song
    QAbstractListModel <|-- SongModel
    QObject <|-- Window

    SongModel "1" --> "*" Song : contains
    Window "1" --> "1" SongModel : uses
    QGuiApplication "1" --> "1" QQmlApplicationEngine : creates
    QQmlApplicationEngine "1" --> "1" Window : loads
```

- Interfacing C++ Model with ListView in Qml

```mermaid
classDiagram
    class SongModel {
        -m_songs: QList<Song*>
        +SongModel(QObject *parent)
        +addSong(Song *song)
        +rowCount(const QModelIndex &parent) int
        +data(const QModelIndex &index, int role) QVariant
        +count() int
        +get(int index) QVariantMap
        +loadSongsFromDirectory(const QString &path)
        -roleNames() QHash<int, QByteArray>
    }

    class Song {
        -m_title: QString
        -m_singer: QString
        -m_icon: QString
        -m_source: QString
        +Song(QString title, QString singer, QString icon, QString source)
        +title() QString
        +singer() QString
        +icon() QString
        +source() QString
    }

    class QAbstractListModel {
        <<abstract>>
    }

    class ListView {
        +model: SongModel
        +delegate: Item
    }

    class SongDelegate {
        +MouseArea
        +Image
        +Column
          -Text: title
          -Text: singer
    }

    SongModel --|> QAbstractListModel
    SongModel "1" *-- "*" Song
    ListView "1" *-- "1" SongModel
    ListView "1" *-- "*" SongDelegate

    note for SongModel "Roles:\nTitleRole\nSingerRole\nIconRole\nSourceRole"
    note for Song "Represents a single song"
    note for ListView "UI component in QML"
    note for SongDelegate "UI representation of a Song"
```
