#ifndef GEOLOCATIONINFO_H
#define GEOLOCATIONINFO_H

#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>

class GeoLocationInfo : public QObject
{
    Q_OBJECT
public:
    GeoLocationInfo(QObject *parent = nullptr)
        : QObject(parent)
    {
        QGeoPositionInfoSource *source = QGeoPositionInfoSource::createDefaultSource(this);
        if(source)
        {
            connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)),
                    this, SLOT(positionUpdatedSlot(QGeoPositionInfo)));
            source->startUpdates();
        }
    }
    Q_INVOKABLE double getLat() const
    { return this->lat; }
    Q_INVOKABLE double getLon() const
    { return this->lon; }
private slots:
    void positionUpdatedSlot(const QGeoPositionInfo &info)
    {
        this->lat = info.coordinate().latitude();
        this->lon = info.coordinate().longitude();
        emit(positionUpdated(info));
    }
signals:
    void positionUpdated(const QGeoPositionInfo &update);
private:
    double lat;
    double lon;
};

#endif // GEOLOCATIONINFO_H
