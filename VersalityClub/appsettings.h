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

// Wrapper, so I can use functionality of QSettings in QML
// Stores user sensetive data and app states for recreation
#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QGuiApplication>
#include <QSettings>
#include <QSet>

class AppSettings : public QSettings
{
    Q_OBJECT

public:
    explicit AppSettings(QObject *parent = nullptr) :
        QSettings(QSettings::IniFormat, QSettings::UserScope,
                  QCoreApplication::instance()->organizationName(),
                  QCoreApplication::instance()->applicationName(),
                  parent)
    {

        //clears promotions and company cache on each app launch
        if(needToRemovePromsAndComps)
        {
            needToRemovePromsAndComps = false;
            this->remove("promo");
            this->remove("company");

            // TODO DELETE AFTER LAUNCH
            //clearAllAppSettings();
        }
    }

    static bool needToRemovePromsAndComps;

    Q_INVOKABLE void setValue(const QString& key, const QVariant& value)
    { QSettings::setValue(key, value); }
    Q_INVOKABLE QVariant value(const QString& key, const QVariant &defaultValue = QVariant())
    { return QSettings::value(key, defaultValue); }
    Q_INVOKABLE void remove(const QString& key)
    { QSettings::remove(key); }
    Q_INVOKABLE void beginGroup(const QString &prefix)
    { QSettings::beginGroup(prefix); }
    Q_INVOKABLE void endGroup()
    { QSettings::endGroup(); }
    Q_INVOKABLE QSet<quint32> getSelectedCats() const
    { return this->selectedCats; }
    Q_INVOKABLE quint32 insertCat(quint32 catId)
    { return *this->selectedCats.insert(catId); }
    Q_INVOKABLE bool contains(quint32 catId) const
    { return this->selectedCats.find(catId) != this->selectedCats.constEnd(); }
    Q_INVOKABLE bool removeCat(quint32 catId)
    { return this->selectedCats.remove(catId); }
    Q_INVOKABLE void clearAllAppSettings()
    { this->clear(); }
    //serialize categories for request param
    Q_INVOKABLE QString getStrCats() const
    {
        QString strCats;
        for(auto cat : this->selectedCats)
            strCats.append(QString::number(cat)).append(',');
        strCats.chop(1);

        return strCats;
    }
    Q_INVOKABLE int getCatsAmount() const
    { return selectedCats.size(); }
    Q_INVOKABLE void setAllCatsUp()
    {
        quint32 catId;
        for(catId = 101; catId <= 107; catId++)
            this->insertCat(catId);
        for(catId = 201; catId <= 205; catId++)
            this->insertCat(catId);
        for(catId = 301; catId <= 304; catId++)
            this->insertCat(catId);
        for(catId = 401; catId <= 410; catId++)
            this->insertCat(catId);
        for(catId = 501; catId <= 504; catId++)
            this->insertCat(catId);
        for(catId = 601; catId <= 604; catId++)
            this->insertCat(catId);
        for(catId = 701; catId <= 705; catId++)
            this->insertCat(catId);
        for(catId = 801; catId <= 802; catId++)
            this->insertCat(catId);
        for(catId = 901; catId <= 904; catId++)
            this->insertCat(catId);
        for(catId = 1001; catId <= 1005; catId++)
            this->insertCat(catId);
        for(catId = 1101; catId <= 1113; catId++)
            this->insertCat(catId);
    }
private:
    QSet<quint32> selectedCats;
};

#endif // APPSETTINGS_H
