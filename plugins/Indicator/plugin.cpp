#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "indicator.h"
#include "settings.h"
#include "commandrunner.h"

void IndicatorPlugin::registerTypes(const char *uri) {
    //@uri Indicator
    qmlRegisterSingletonType<CommandRunner>(uri, 1, 0, "CommandRunner", [](QQmlEngine*, QJSEngine*) -> QObject* { return new CommandRunner; });
    qmlRegisterSingletonType<Indicator>(uri, 1, 0, "Indicator", [](QQmlEngine*, QJSEngine*) -> QObject* { return new Indicator; });
    qmlRegisterType<Settings>(uri, 1, 0, "Settings");
}

void IndicatorPlugin::initializeEngine(QQmlEngine *engine, const char *uri) {
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
