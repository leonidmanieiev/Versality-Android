#ifndef PAGENAMEHOLDER_H
#define PAGENAMEHOLDER_H

#include <QObject>
#include <QStack>
#include <QString>
#include <QDebug>

class PageNameHolder : public QObject
{
    Q_OBJECT
public:
    explicit PageNameHolder(QObject *parent = nullptr) :
        QObject(parent) { }
    Q_INVOKABLE QString pop()
    {
        if(!this->empty())
        {
            QString poped = pageNames.pop();
            qDebug() << "Poped: " << poped;
                return poped;
        }
        qDebug() << "Poped: \"\"";
        return "";
    }
    Q_INVOKABLE void push(const QString& pageName)
    {
        qDebug() << "Pushed: " << pageName;
        pageNames.push(pageName);
    }
    Q_INVOKABLE void clear()
        { pageNames.clear(); }
    Q_INVOKABLE bool empty() const
        { return pageNames.empty(); }
private:
    QStack<QString> pageNames;
};

#endif // PAGENAMEHOLDER_H
