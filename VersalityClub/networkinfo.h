#ifndef NETWORKINFO_H
#define NETWORKINFO_H

#include <QNetworkAccessManager>

class NetworkInfo : public QNetworkAccessManager
{
    Q_OBJECT

public:
    explicit NetworkInfo(QObject *parent = nullptr) :
        QNetworkAccessManager(parent) { }
    Q_INVOKABLE QNetworkAccessManager::NetworkAccessibility networkStatus() const
        { return QNetworkAccessManager::networkAccessible(); }
};

#endif // NETWORKINFO_H
