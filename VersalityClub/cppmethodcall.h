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

// Wrapper, so I can call cpp methods from QML
#ifndef CPPMETHODCALL_H
#define CPPMETHODCALL_H

#include "appsettings.h"

#include <QDebug>
#include <QFile>
#include <QObject>
#include <QQmlEngine>
#include <QStandardPaths>
#include <QTextStream>

class CppMethodCall : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(CppMethodCall)
public:
    explicit CppMethodCall([[maybe_unused]] QObject *parent = nullptr) { }
    ~CppMethodCall() = default;

    Q_INVOKABLE static void saveHashToFile()
    {
        //if user has an account so do hash
        if(!AppSettings().value("user/hash").toString().isEmpty())
        {
            // creating file
            QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)+"/hash.txt");
            if(!file.open(QIODevice::WriteOnly | QIODevice::Text))
            {
                qDebug() << "CppMethodCall::saveHashToFile: failed to open 'hash.txt'";
                return;
            }

            // saving user hash to file
            QTextStream out(&file);
            out << AppSettings().value("user/hash").toString();
            out.flush();
            file.close();

            qDebug() << "CppMethodCall::saveHashToFile: user hash has been saved to the file";
        }
        else qDebug() << "CppMethodCall::saveHashToFile: No user hash yet";
    }

    static QObject* singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine);
        Q_UNUSED(scriptEngine);

        CppMethodCall* intance = new CppMethodCall();
        return intance;
    }
};

#endif // CPPMETHODCALL_H
