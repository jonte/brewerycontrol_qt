#include "eventsource.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    QFontDatabase fontDatabase;

    QString fonts[] = {":/Segment7Standard.otf", ":/ImpactLabel-lVYZ.ttf", ":/Cantarell-Regular.ttf"};
    for (QString font: fonts) {
        if (QFontDatabase::addApplicationFont(font) < 0) {
            qWarning() << "Failed to load font: " << font;
        }
    }

    app.setFont(QFont("Cantarell"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    EventSource es(QUrl("http://bryggmaestarn:5000/v1"));
    //EventSource es(QUrl("http://localhost:5000/v1"));

    engine.rootContext()->setContextProperty("eventsource", &es);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
