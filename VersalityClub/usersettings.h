/****************************************************************************
**
** Copyright (C) 2018 Leonid Manieiev.
** Contact: leonid.manieiev@gmail.com
**
** This file is part of Versality Club.
**
** Versality Club is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** Versality Club is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
**
****************************************************************************/


//Wrapper, so I can use functionality of QSettings in QML
//Stores user sensetive data and app states for recreation
#ifndef USERSETTINGS_H
#define USERSETTINGS_H

#include <QGuiApplication>
#include <QSettings>

class UserSettings : public QSettings
{
    Q_OBJECT

public:
    explicit UserSettings(QObject *parent = nullptr) :
        QSettings(QSettings::IniFormat, QSettings::UserScope,
                  QCoreApplication::instance()->organizationName(),
                  QCoreApplication::instance()->applicationName(),
                  parent)
    {
        this->beginGroup("user_security");
        this->setValue("for_xor", "8fdda158eeb8c0ed9d151991aff3c84c");
        this->endGroup();
        //this->remove("user_security/user_hash");//DONT FORGET TO DELETE THIS
    }
    Q_INVOKABLE void setValue(const QString& key, const QVariant& value)
        { QSettings::setValue(key, value); }
    Q_INVOKABLE QVariant value(const QString& key, const QVariant &defaultValue = QVariant()) const
        { return QSettings::value(key, defaultValue); }
    Q_INVOKABLE void remove(const QString& key)
        { QSettings::remove(key); }
    Q_INVOKABLE void beginGroup(const QString &prefix)
        { QSettings::beginGroup(prefix); }
    Q_INVOKABLE void endGroup()
        { QSettings::endGroup(); }
};

#endif // USERSETTINGS_H
