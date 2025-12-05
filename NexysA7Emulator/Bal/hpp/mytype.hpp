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

//-only-file header
//-var {PRE} "MyType::"mytype
class MyType : public MyTypePrivate {
    Q_OBJECT
    QML_ELEMENT

public:
    //- {function} 1 1
    explicit MyType(QObject *parent = nullptr)
        //-only-file body
        : MyTypePrivate(parent) {

        QObject::connect(&timer, &QTimer::timeout, [this]() { getLedStatus(); });
        writeSwStatus();

        timer.start(100);
    }

    //-only-file header
public slots:

    //- {fn}
    void writeSwStatus()
    //-only-file body
    {
        QFile file("/Volumes/RAM_Disk_4G/tmpFifo/mySw");

        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            qDebug() << "Could not open file for writing!";
            return;
        }
        QTextStream out(&file);
        out << swStr() << "\n";
        file.close();
    }

    //- {fn}
    void writeBtnStatus(QString cpuResetn, QString btnu, QString btnl,
                        QString btnc, QString btnr, QString btnd)
    //-only-file body
    {

        QFile file("/Volumes/RAM_Disk_4G/tmpFifo/myBtns");

        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            qDebug() << "Could not open file for writing!";
            return;
        }
        QTextStream out(&file);
        out << cpuResetn << " " << btnu << " " << btnl << " " << btnc << " " << btnr
            << " " << btnd << "\n";
        file.close();
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
    bool getLedStatus()
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
            setLedStr(s.at(2).split(":").at(1).trimmed());
        }

        file.close();
        return true;
    }

    //-only-file header
};
