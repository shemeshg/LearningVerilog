//-define-file header prptHpp/MyTypePrivate.h
//-only-file header //-
#pragma once

#include <QObject>
#include <QObjectComputedProperty>
#include <QQmlEngine>
#include <QColor>


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
    Q_PROPERTY(QList<QColor> rgbLeds READ rgbLeds  NOTIFY rgbLedsChanged )
    
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


    
    QList<QColor> rgbLeds() const{return m_rgbLeds;} 
    

    
    
    
signals:
    void statusTextChanged();
    void rgbLedsChanged();
    

protected:
    QList<QColor> m_rgbLeds { QColor(0,0,0), QColor(0,0,0) };
    

private:
    QString m_statusText {"Not started"};
    
};
//-only-file null

//[[[end]]]
