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

    }

    //-only-file header
public slots:
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
            qDebug() << line;
        }

        file.close();
        qDebug() << "Finished!!";
        return true;
    }

    //- {fn}
    void asyncGetShalom(const QJSValue &callback)
    //-only-file body
    {
        makeAsync<bool>(callback, [=]() {
            return getShalom();
        });

    }

//-only-file header
signals:


private slots:

    
private:


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
};
