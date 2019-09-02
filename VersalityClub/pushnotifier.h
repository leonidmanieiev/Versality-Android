/****************************************************************************
**
** Copyright (C) 2019 Leonid Manieiev.
** Contact: leonid.manieiev@gmail.com
**
** This file is part of Versality.
**
** Versality is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** Versality is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Versality. If not, see <https://www.gnu.org/licenses/>.
**
****************************************************************************/

// will notify qml about incoming push when app is already running
#ifndef PUSHNOTIFIER_H
#define PUSHNOTIFIER_H

#include <QObject>
#include <QQmlEngine>

class PushNotifier : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(PushNotifier)
    Q_PROPERTY(QString promoId READ promoId WRITE setPromoId NOTIFY promoIdChanged)
public:
    explicit PushNotifier(QObject *parent = nullptr);
    ~PushNotifier();
    static QObject* singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
    static PushNotifier* instance();

public slots:
    QString promoId() const;
    void setPromoId(const QString& pid);

signals:
    void promoIdChanged(QString pid);

private:
    QString mPromoId;
};

#endif // PUSHNOTIFIER_H
