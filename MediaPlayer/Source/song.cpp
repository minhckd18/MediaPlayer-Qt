#include "song.h"

Song::Song(QString title, QString singer, QString icon, QString source)
    : m_title(title), m_singer(singer), m_icon(icon), m_source(source)
{}

QString Song::title() const
{
    return m_title;
}

QString Song::singer() const
{
    return m_singer;
}

QString Song::icon() const
{
    return m_icon;
}

QString Song::source() const
{
    return m_source;
}

