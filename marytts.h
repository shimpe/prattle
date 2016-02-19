#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QList>
#include <QString>

class QNetworkReply;
class QSound;

class MaryTTS : public QObject
{
    Q_OBJECT

public:
    explicit MaryTTS(QObject *parent = 0);
    ~MaryTTS();

    Q_INVOKABLE void synthesize(const QString &text, const QString &voice, const QString &locale, bool FromClipboard);
    Q_INVOKABLE void stopSound();
    Q_PROPERTY(QString filePath READ getFilePath WRITE setFilePath NOTIFY filePathChanged)

    QString getFilePath() const;
    void setFilePath(const QString &str);

public slots:
    void serviceRequestFinished(QNetworkReply *);

signals:
    void filePathChanged();

private:    
    void startSound(QString fPath);

    QString m_filePath;
    QSound *m_sound;
};

#endif // FILEIO_H
