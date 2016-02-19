#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "marytts.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("MaryTTS", new MaryTTS());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
