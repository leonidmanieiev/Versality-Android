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

// Wrapper, so I can ask for location
#ifndef ENABLELOCATION_H
#define ENABLELOCATION_H

#include "jni.h"

#include <QDebug>
#include <QObject>
#include <QtAndroid>
#include <QQmlEngine>
#include <QtAndroidExtras>

class EnableLocation : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(EnableLocation)
public:
    explicit EnableLocation([[maybe_unused]] QObject *parent = nullptr) :
        QObject(parent) { }
    ~EnableLocation() = default;

    Q_INVOKABLE static bool askEnableLocation()
    {
        jboolean locEnabled = QtAndroid::androidActivity().callMethod<jboolean>("isLocationEnabled");
        auto locPerm = QtAndroid::checkPermission("android.permission.ACCESS_FINE_LOCATION");

        if(!locEnabled) {
            QtAndroid::androidActivity().callMethod<void>("askToEnableLocationWithLooper");
            return false;
        } else if (locPerm == QtAndroid::PermissionResult::Denied) {
            QtAndroid::androidActivity().callMethod<void>("askToGrantPermissionWithLooper");
            return false;
        }

        return true;
    }

    static QObject* singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine);
        Q_UNUSED(scriptEngine);

        EnableLocation* intance = new EnableLocation();
        return intance;
    }
};

#endif // ENABLELOCATION_H
