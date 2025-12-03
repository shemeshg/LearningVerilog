//-define-file header prptHpp/MyTypePrivate.h
//-only-file header //-
#pragma once

#include <QObject>
#include <QObjectComputedProperty>
#include <QQmlEngine>



//-only-file null
/*[[[cog
import cog
from MyTypePrivate import prptClass


cog.outl(prptClass.getClassHeader(),
        dedent=True, trimblanklines=True)

]]] */
//-only-file header
class MyTypePrivate : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString statusText READ statusText WRITE setStatusText NOTIFY statusTextChanged )

    QML_ELEMENT
public:

    MyTypePrivate(QObject *parent):QObject(parent){}

    virtual ~MyTypePrivate() {

    }



    QString statusText() const{return m_statusText;}

void setStatusText(const QString &newStatusText)
    {
        if (m_statusText == newStatusText)
            return;
        m_statusText = newStatusText;
        emit statusTextChanged();
    }





signals:
    void statusTextChanged();


protected:


private:
    QString m_statusText {"Not connected"};

};
//-only-file null

//[[[end]]]
