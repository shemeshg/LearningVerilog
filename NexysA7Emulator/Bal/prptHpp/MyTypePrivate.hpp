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
    Q_PROPERTY(QString timeStr READ timeStr WRITE setTimeStr NOTIFY timeStrChanged )
    Q_PROPERTY(QString ledStr READ ledStr WRITE setLedStr NOTIFY ledStrChanged )
    
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


    
    QString timeStr() const{return m_timeStr;} 
    
void setTimeStr(const QString &newTimeStr)
    {
        if (m_timeStr == newTimeStr)
            return;
        m_timeStr = newTimeStr;
        emit timeStrChanged();
    }


    
    QString ledStr() const{return m_ledStr;} 
    
void setLedStr(const QString &newLedStr)
    {
        if (m_ledStr == newLedStr)
            return;
        m_ledStr = newLedStr;
        emit ledStrChanged();
    }


    
    
    
signals:
    void statusTextChanged();
    void timeStrChanged();
    void ledStrChanged();
    

protected:
    

private:
    QString m_statusText {"Not connected"};
    QString m_timeStr {};
    QString m_ledStr {"0000000000000000"};
    
};
//-only-file null

//[[[end]]]
