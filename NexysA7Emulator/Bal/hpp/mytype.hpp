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
#include <QClipboard>
#include <QGuiApplication>

//- {include-header}
#include "../prptHpp/MyTypePrivate.hpp" //- #include "../prptHpp/MyTypePrivate.h"
//- {include-header}
#include "EmulatorWorker.hpp" //- #include "EmulatorWorker.h"

//-only-file header
//-var {PRE} "MyType::"
class MyType : public MyTypePrivate {
    Q_OBJECT
    QML_ELEMENT

public:
    //- {function} 1 1
    explicit MyType(QObject *parent = nullptr)
        //-only-file body
        : MyTypePrivate(parent) {

        emulatorWorker = new EmulatorWorker();
        thread = new QThread();
        emulatorWorker->moveToThread(thread);
        connect(this, &MyType::_start, emulatorWorker, &EmulatorWorker::start);
        connect(this, &MyType::_stop, emulatorWorker, &EmulatorWorker::stop);
        connect(this, &MyType::_writeBtnStatus, emulatorWorker, &EmulatorWorker::writeBtnStatus);

        connect(thread, &QThread::finished, emulatorWorker, &QObject::deleteLater);
        thread->start();

    }

    //- {function} 1 1
    virtual ~MyType()
    //-only-file body
    {
        QMetaObject::invokeMethod(emulatorWorker, "stop", Qt::QueuedConnection);

        thread->quit();   // tell the event loop to exit
    }

//-only-file header
public slots:
    void start(){
        emit _start();
    }

    void stop(){
        emit _stop();
    }

    void writeBtnStatus(int cpuResetn, int btnu, int btnl,
                        int btnc, int btnr, int btnd, int sw){
        emit _writeBtnStatus(cpuResetn, btnu, btnl,
                             btnc, btnr, btnd, sw);;
    }

signals:
    void _stop();
    void _start();
    void _writeBtnStatus(int cpuResetn, int btnu, int btnl,
                         int btnc, int btnr, int btnd, int sw);

private slots:

private:
    EmulatorWorker *emulatorWorker;
    QThread *thread;
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



    //-only-file header
};
