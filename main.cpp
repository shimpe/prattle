#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "marytts.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QScopedPointer<MaryTTS> M(new MaryTTS());
    engine.rootContext()->setContextProperty("MaryTTS", M.data());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
