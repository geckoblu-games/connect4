#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>
// include qml context, required to add a context property
#include <QQmlContext>
#include <QLatin1String>
#include <QDebug>
#include <QMetaObject>
#include <QDir>

#include <cstdlib> // for std::rand() and std::srand()
#include <ctime> // for std::time()

// include custom classes
#include "gamemodel.hpp"
#include "levelclass.hpp"

int main(int argc, char *argv[])
{
    std::srand(static_cast<unsigned int>(std::time(nullptr))); // set initial seed value to system clock

    // To store application properties
    QGuiApplication::setApplicationName("Connect4");
    QCoreApplication::setOrganizationDomain("geckoblu.net");
    QGuiApplication::setOrganizationName("geckoblu");

    QQuickStyle::setStyle("material");
    QIcon::setThemeSearchPaths({":/icons"});
    QIcon::setThemeName("minimaterial");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/images/connect4.svg"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url, &engine](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
        qDebug() << "Application loaded";
        //qDebug() << &engine.rootObjects().first();
        QObject **app = &engine.rootObjects().first();
        QMetaObject::invokeMethod(*app, "newGame", Qt::QueuedConnection);
    }, Qt::QueuedConnection);

    // register the Level enumeration
    qRegisterMetaType<Level>("Level");
    qmlRegisterUncreatableType<LevelClass>("connect4", 1, 0, "Level", "Not creatable as it is an enum type");

    // Set the working dir to the application dir so that GameModel could find the opening books
    // in the same directory of the executable
    // qDebug() << QCoreApplication::applicationDirPath();
    QDir::setCurrent(QCoreApplication::applicationDirPath());
    // qDebug() << QDir::currentPath();

    // add global c++ object to the QML context as a property
    GameModel* gamemodel = new GameModel();
    engine.rootContext()->setContextProperty("gamemodel", gamemodel); // the object will be available in QML with name "gamemodel"

    engine.load(url);

    auto myElement = engine.rootObjects().first()->findChild<QObject*>(QLatin1String("board"));
    //qDebug() << myElement;

    QObject::connect(gamemodel, SIGNAL(moveChoosed(QVariant)),
                     myElement, SLOT(moveChoosed(QVariant)));

    return app.exec();
}
