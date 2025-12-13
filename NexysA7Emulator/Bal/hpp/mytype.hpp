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




        QObject::connect(&timer, &QTimer::timeout, [this]() {
            getLedStatus();
            get7SegStatus();
        });

        setSettings();
        writeSwStatus();                
        timer.start(100);
    }

    //-only-file header
public slots:

    //- {fn}
    void writeSwStatus()
    //-only-file body
    {
        QFile file(mySw);

        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            qDebug() << "Could not open file for writing!"<<mySw;
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

        QFile file(myBtns);

        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            qDebug() << "Could not open file for writing!"<<myBtns;
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
    QString myLeds, mySegDispllay, mySw, myBtns;

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
    bool get7SegStatus()
    //-only-file body
    {

        QFile file(mySegDispllay);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << "Could not open file!"<<mySegDispllay<<QSysInfo::productType() ;
            return false;
        }

        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            auto s = line.split(" ");
            if (s.size() >= 2)  {
                setSegAn(s.at(0).trimmed());
                setSegCat(s.at(1).trimmed());
            } else {
                qDebug() << "Could not parse file!"<<mySegDispllay<<QSysInfo::productType() ;
            }

        }

        file.close();
        return true;
    }

    //- {fn}
    bool getLedStatus()
    //-only-file body
    {

        QFile file(myLeds);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << "Could not open file!"<<myLeds;
            return false;
        }

        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            auto s = line.split("|");
            if (s.size() >= 2)  {
                setTimeStr(s.at(0).split(":").at(1).trimmed());
                setLedStr(s.at(2).split(":").at(1).trimmed());
            } else {
                qDebug() << "Could not parse file!"<<myLeds;
            }

        }

        file.close();
        return true;
    }

    //- {fn}
    void setSettings()
    //-only-file body
    {
        QSettings settings;

        myLeds = QSysInfo::productType() == "macos" ?
                     "/Volumes/RAM_Disk_4G/tmpFifo/myLeds" : "/dev/shm/myLeds";
        myLeds = settings.value("myLeds",myLeds).toString();

        mySegDispllay = QSysInfo::productType() == "macos" ?
                     "/Volumes/RAM_Disk_4G/tmpFifo/my7SegDispllay" : "/dev/shm/my7SegDispllay";
        mySegDispllay = settings.value("mySegDispllay",myLeds).toString();


        mySw = QSysInfo::productType() == "macos" ?
                            "/Volumes/RAM_Disk_4G/tmpFifo/mySw" : "/dev/shm/mySw";;
        mySw = settings.value("mySw",mySw).toString();

        myBtns = QSysInfo::productType() == "macos" ?
                   "/Volumes/RAM_Disk_4G/tmpFifo/myBtns" : "/dev/shm/myBtns";;
        myBtns = settings.value("myBtns",myBtns).toString();

    }
    //-only-file header
};
