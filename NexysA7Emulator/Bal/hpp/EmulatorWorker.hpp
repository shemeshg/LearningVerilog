//-define-file body hpp/EmulatorWorker.cpp
//-define-file header hpp/EmulatorWorker.h
//-only-file header //-
#pragma once
#include <QObject>

#include "Vtop.h"

//-only-file body //-
//- #include "EmulatorWorker.h"
#include <QDebug>
#include <QThread>
#include <QTimer>
#include <QCoreApplication>
//-only-file header
//-var {PRE} "EmulatorWorker::"
class EmulatorWorker : public QObject
{
    Q_OBJECT
public:
    //- {function} 1 1
    explicit EmulatorWorker(QObject *parent = nullptr)
        //-only-file body
        : QObject(parent)
    {
        dut = new Vtop;
    }
    //-only-file header
    virtual ~EmulatorWorker()
    {
        delete dut;
    }

public slots:
    //- {fn}
    void start()
    //-only-file body
    {
        qDebug() << "DUT started";
        // Reset
        dut->CPU_RESETN = 0;
        for (int i = 0; i < 5; i++)
        {
            dut->CLK100MHZ = 0;
            dut->eval();
            dut->CLK100MHZ = 1;
            dut->eval();
        }
        dut->CPU_RESETN = 1;
        isRunning = true;

        QTimer::singleShot(0, this, &EmulatorWorker::tick);

    }

    //- {fn}
    void stop()
    //-only-file body
    {
        isRunning = false;
        qDebug() << "DUT staped";
    }

    //-only-file header
private:
    Vtop *dut;
    bool isRunning = false;
    const int INTERVAL = 100000;
    int clockCounter =0;

    //- {fn}
    void tick()
    //-only-file body
    {
        while (isRunning) {
            dut->CLK100MHZ ^= 1;
            dut->eval();

            clockCounter++;
            if (clockCounter >= INTERVAL) {
                clockCounter = 0;
                qDebug() << "Tick";
                QCoreApplication::processEvents();
                QThread::yieldCurrentThread();
            }
        }
    }

    //-only-file header
};
