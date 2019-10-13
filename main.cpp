#include "eventsource.h"
#include "settings.h"

#include <QFontDatabase>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

bool loadFonts(QApplication *app) {
    QFontDatabase fontDatabase;

    QString fonts[] = {
        ":/Segment7Standard.otf",
        ":/ImpactLabel-lVYZ.ttf",
        ":/Cantarell-Regular.ttf",
        ":/Font Awesome 5 Free-Solid-900.otf"
    };

    for (QString font: fonts) {
        if (QFontDatabase::addApplicationFont(font) < 0) {
            qWarning() << "Failed to load font: " << font;
            return false;
        }
    }

    app->setFont(QFont("Cantarell"));
    return true;
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Settings settings;

    if (!loadFonts(&app)) {
        qCritical() << "Failed to load fonts - exiting";
        return -1;
    }

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    EventSource es(QUrl(settings.value("host", "http://localhost:5000/v1").toString()));

    engine.rootContext()->setContextProperty("eventsource", &es);
    engine.rootContext()->setContextProperty("settings", &settings);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
