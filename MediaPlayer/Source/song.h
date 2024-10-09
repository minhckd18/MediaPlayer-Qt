#ifndef SONG_H
#define SONG_H

#include <QObject>

class Song
{
public:
    Song(QString title, QString singer, QString icon, QString source);

    QString title() const;
    QString singer() const;
    QString icon() const;
    QString source() const;

private:
    QString m_title;
    QString m_singer;
    QString m_icon;
    QString m_source;
};

#endif // SONG_H
