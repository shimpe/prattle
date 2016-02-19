#include "marytts.h"
#include <QIODevice>
#include <QFile>
#include <QDataStream>
#include <QNetworkAccessManager>
#include <QUrl>
#include <QUrlQuery>
#include <QByteArray>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QStandardPaths>
#include <QDir>
#include <QSound>
#include <QClipboard>
#include <QMimeData>
#include <QApplication>

MaryTTS::MaryTTS(QObject *parent)
    : QObject(parent)
    , m_sound(0)
{

}

MaryTTS::~MaryTTS()
{

}

void MaryTTS::synthesize(const QString &text, const QString &voice, const QString &locale, bool FromClipboard)
{
    QNetworkAccessManager *networkManager = new QNetworkAccessManager(this);
    connect(networkManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(serviceRequestFinished(QNetworkReply*)));

    QString InputText;

    QUrlQuery postData;
    if (FromClipboard)
    {
        const QClipboard *clipboard = QApplication::clipboard();
        const QMimeData *mimeData = clipboard->mimeData();
        if (mimeData->hasText())
        {
            InputText = mimeData->text();
        }
    }
    else
    {
        InputText = text;
    }

    if (!InputText.trimmed().isEmpty())
    {
        postData.addQueryItem("INPUT_TYPE", "TEXT");
        postData.addQueryItem("OUTPUT_TYPE", "AUDIO");
        postData.addQueryItem("LOCALE", locale);
        postData.addQueryItem("AUDIO", "WAVE_FILE");
        postData.addQueryItem("VOICE", voice);
        postData.addQueryItem("INPUT_TEXT", InputText);

        QUrl serviceUrl("http://localhost:59125/process");
        QNetworkRequest request(serviceUrl);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

        //qDebug() << postData.toString(QUrl::FullyEncoded).toUtf8();
        networkManager->post(request, postData.toString(QUrl::FullyEncoded).toUtf8());
    }
}

void MaryTTS::stopSound()
{
    if (m_sound)
    {
        m_sound->stop();
        delete m_sound;
        m_sound = 0;
    }
}

QString MaryTTS::getFilePath() const
{
    return m_filePath;
}

void MaryTTS::setFilePath(const QString &str)
{
    m_filePath = str;
}

void MaryTTS::startSound(QString fPath)
{
    m_sound = new QSound(fPath);
    m_sound->play();
}

void MaryTTS::serviceRequestFinished(QNetworkReply *reply)
{
    QString response;
    QByteArray buffer;

    if (reply)
    {
        if (reply->error() == QNetworkReply::NoError)
        {
            const int available = reply->bytesAvailable();
            if (available > 0)
            {
                buffer = reply->readAll();
            }
        }
        else
        {
            response = tr("Error: %1 status: %2").arg(reply->errorString(), reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString());
            qDebug() << response;
        }

        reply->deleteLater();
    }

    if (buffer.isEmpty())
    {
        response = tr("Unable to retrieve post response");
        qDebug() << response;
    }
    else
    {
        QString path = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
        QString fPath = path + QDir::separator() + "say.wav";
        QFile file(fPath);

        if (file.exists())
            file.remove();

        if (file.open(QIODevice::ReadWrite))
        {
            QDataStream stream(&file);
            stream.writeRawData(buffer,buffer.length());
        }

        setFilePath(fPath);
        emit filePathChanged();

        stopSound();
        startSound(fPath);
    }
}

