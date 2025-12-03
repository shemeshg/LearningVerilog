//-define-file body hpp/mytype.cpp
//-define-file header hpp/mytype.h
//-only-file header //-
#pragma once
#include <QObject>
#include <qqmlregistration.h>

#include <QJSEngine>
#include <QtConcurrent>


//-only-file body //-
//- #include "mytype.h"
#include <QGuiApplication>
#include <QClipboard>


//- {include-header}
#include "../prptHpp/MyTypePrivate.hpp" //- #include "../prptHpp/MyTypePrivate.h"


//-only-file header
//-var {PRE} "MyType::"mytype
class MyType : public MyTypePrivate {
    Q_OBJECT
    QML_ELEMENT

public:
    //- {function} 1 1
    explicit MyType(QObject *parent = nullptr)
        //-only-file body
        : MyTypePrivate(parent){

        QObject::connect(&timer, &QTimer::timeout, [this](){
            getShalom();
        });

    }

    //-only-file header
public slots:


    //- {fn}
    void startShalom()
    //-only-file body
    {
        timer.start(500);

    }

    //- {fn}
    void stopShalom()
    //-only-file body
    {
        timer.stop();

    }

//-only-file header
signals:


private slots:

    
private:

    QTimer timer;

    template <typename T>
    void makeAsync(const QJSValue &callback, std::function<T()> func) {
        auto *watcher = new QFutureWatcher<T>(this);
        QObject::connect(watcher, &QFutureWatcher<T>::finished, this,
                         [this, watcher, callback]() {
            T returnValue = watcher->result();
            QJSValue cbCopy(callback);
            QJSEngine *engine = qjsEngine(this);
            cbCopy.call(
                QJSValueList{engine->toScriptValue(returnValue)});
            watcher->deleteLater();
        });
        watcher->setFuture(QtConcurrent::run([=]() { return func(); }));
    }


    //- {fn}
    bool getShalom()
    //-only-file body
    {

        QFile file("/Volumes/RAM_Disk_4G/tmpFifo/myLeds");
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << "Could not open file!";
            return false;
        }

        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            auto s = line.split("|");
            setTimeStr(s.at(0).split(":").at(1).trimmed());
            setLedStr(s.at(3).split(":").at(1).trimmed());
            qDebug()<<ledStr();

        }

        file.close();
        return true;
    }


    //-only-file header
};
