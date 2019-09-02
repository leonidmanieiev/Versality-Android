#include "pushnotifier.h"
#include <QDebug>

PushNotifier::PushNotifier(QObject *parent ) : QObject(parent) { }

PushNotifier::~PushNotifier() { }

QObject* PushNotifier::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    return PushNotifier::instance();
}

PushNotifier* PushNotifier::instance() {
    static PushNotifier* pushNotifier = new PushNotifier();
    return pushNotifier;
}

QString PushNotifier::promoId() const {
    return mPromoId;
}

void PushNotifier::setPromoId(const QString& pid) {
    mPromoId = pid;
    emit promoIdChanged(mPromoId);
}
