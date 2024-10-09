#include "songmodel.h"

SongModel::SongModel(QObject *parent) : QAbstractListModel(parent)
{}

void SongModel::addSong(Song *song)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_songs.append(song);
    endInsertRows();
    emit countChanged();
}

int SongModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_songs.count();
}

QVariant SongModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() >= m_songs.count())
        return QVariant();

    Song *song = m_songs[index.row()];
    if (role == TitleRole)
        return song->title();
    else if (role == SingerRole)
        return song->singer();
    else if (role == IconRole)
        return song->icon();
    else if (role == SourceRole)
        return song->source();

    return QVariant();
}

int SongModel::count() const
{
    return m_songs.count();
}

QVariantMap SongModel::get(int index) const
{
    if (index < 0 || index >= m_songs.count())
        return QVariantMap();

    Song *song = m_songs[index];
    QVariantMap map;
    map["title"] = song->title();
    map["singer"] = song->singer();
    map["icon"] = song->icon();
    map["source"] = song->source();
    return map;
}

void SongModel::loadSongsFromDirectory(const QString &path)
{
    QDir directory(path);
    QStringList filters;
    filters << "*.mp3";
    QFileInfoList musics = directory.entryInfoList(filters, QDir::Files);

    // Create a temporary directory for album art
    QString tempPath = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/AlbumArt";
    QDir tempDir(tempPath);
    if (!tempDir.exists()) {
        tempDir.mkpath(".");
    }

    beginResetModel();
    qDeleteAll(m_songs);
    m_songs.clear();

    foreach (const QFileInfo &fileInfo, musics) {
        QString filePath = fileInfo.absoluteFilePath();

        TagLib::MPEG::File mpegFile(filePath.toStdString().c_str());
        TagLib::ID3v2::Tag *id3v2Tag = mpegFile.ID3v2Tag();

        if (id3v2Tag) {
            QString title = QString::fromStdString(id3v2Tag->title().to8Bit(true));
            QString singer = QString::fromStdString(id3v2Tag->artist().to8Bit(true));

            if (title.isEmpty()) title = fileInfo.baseName();
            if (singer.isEmpty()) singer = "Unknown";

            // Save album art to a file
            QString icon = "qrc:/Image/album_art.png";
            TagLib::ID3v2::FrameList frames = id3v2Tag->frameListMap()["APIC"];
            if (!frames.isEmpty()) {
                auto *frame = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame*>(frames.front());

                if (frame) {
                    QByteArray imageData(frame->picture().data(), frame->picture().size());

                    // Save the album art to a file
                    QString imgFileName = tempPath + "/" + fileInfo.baseName() + ".jpg";
                    QFile imgFile(imgFileName);
                    if (imgFile.open(QIODevice::WriteOnly)) {
                        imgFile.write(imageData);
                        imgFile.close();
                        qDebug() << "Album art saved";
                        icon = QUrl::fromLocalFile(imgFileName).toString();
                    } else {
                        qDebug() << "Failed to save album art";
                    }
                }
            } else {
                qDebug() << "No album art found.";
            }

            Song *song = new Song(title, singer, icon, filePath);
            m_songs.append(song);
        }
        else {
            qDebug() << "Fail to read Tag";
        }
    }

    endResetModel();
    emit countChanged();
}

QHash<int, QByteArray> SongModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[SingerRole] = "singer";
    roles[IconRole] = "icon";
    roles[SourceRole] = "source";
    return roles;
}
