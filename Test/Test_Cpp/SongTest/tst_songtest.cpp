#include <QCoreApplication>
#include <QtTest>

#include "song.h"

class SongTest : public QObject
{
    Q_OBJECT

public:
    SongTest();
    ~SongTest();

private slots:
    void testConstructor_data();
    void testConstructor();
    void testGetters();
};

SongTest::SongTest() {}

SongTest::~SongTest() {}

void SongTest::testConstructor_data() {
    QTest::addColumn<QString>("title");
    QTest::addColumn<QString>("singer");
    QTest::addColumn<QString>("icon");
    QTest::addColumn<QString>("source");

    QTest::newRow("normal case") << "Song Title" << "Singer Name" << "icon.png" << "song.mp3";
    QTest::newRow("empty fields") << "" << "" << "" << "";
    QTest::newRow("long strings") << QString(1000, 'a') << QString(1000, 'b') << QString(500, 'c') << QString(500, 'd');
    QTest::newRow("special characters") << "@#$%^&*" << "Singer%$#!" << "icon@!#.png" << "song%@!.mp3";
    QTest::newRow("null characters in fields")
        << QString::fromUtf8("Title\0Extra", 11)
        << QString::fromUtf8("Singer\0Data", 12)
        << QString::fromUtf8("icon\0.png", 9)
        << QString::fromUtf8("song\0.mp3", 9);
}

void SongTest::testConstructor() {
    QFETCH(QString, title);
    QFETCH(QString, singer);
    QFETCH(QString, icon);
    QFETCH(QString, source);

    Song song(title, singer, icon, source);

    QCOMPARE(song.title(), title);
    QCOMPARE(song.singer(), singer);
    QCOMPARE(song.icon(), icon);
    QCOMPARE(song.source(), source);
}

void SongTest::testGetters() {
    Song song("Test Title", "Test Singer", ":/icons/test.png", "test.mp3");

    QVERIFY(song.title() == "Test Title");
    QVERIFY(song.singer() == "Test Singer");
    QVERIFY(song.icon() == ":/icons/test.png");
    QVERIFY(song.source() == "test.mp3");
}

QTEST_MAIN(SongTest)

#include "tst_songtest.moc"
