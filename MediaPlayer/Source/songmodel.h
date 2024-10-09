#ifndef SONGMODEL_H
#define SONGMODEL_H

#include <QAbstractListModel>
#include <QVariantMap>
#include <QDir>
#include <QUrl>
#include <QDebug>
#include <QStandardPaths>
#include "song.h"

// Taglib
#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/id3v2tag.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2frame.h>
#include <taglib/id3v2header.h>
#include <taglib/attachedpictureframe.h>

class SongModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    enum SongRoles {
        TitleRole = Qt::UserRole + 1,
        SingerRole,
        IconRole,
        SourceRole
    };

    explicit SongModel(QObject *parent = nullptr);

    void addSong(Song *song);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    int count() const;
    Q_INVOKABLE QVariantMap get(int index) const;
    Q_INVOKABLE void loadSongsFromDirectory(const QString &path);

protected:
    QHash<int, QByteArray> roleNames() const override;

signals:
    void countChanged();

private:
    QList<Song*> m_songs;
};

#endif // SONGMODEL_H
