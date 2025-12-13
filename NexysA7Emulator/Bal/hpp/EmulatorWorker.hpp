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
    explicit EmulatorWorker(QObject *parent= nullptr)
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
        //qDebug() << "DUT started";
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
        emit setRunningStatus(isRunning);
        QTimer::singleShot(0, this, &EmulatorWorker::tick);
    }

    //- {fn}
    void writeBtnStatus(int cpuResetn, int btnu, int btnl,
                        int btnc, int btnr, int btnd, int sw)
    //-only-file body
    {
        dut->CPU_RESETN = !cpuResetn;
        dut->BTNU = btnu;
        dut->BTNL = btnl;
        dut->BTNC = btnc;
        dut->BTNR = btnr;
        dut->BTND = btnd;
        dut->SW = sw;
    }

    //- {fn}
    void stop()
    //-only-file body
    {
        isRunning = false;
        //qDebug() << "DUT stoped";
        emit setRunningStatus(isRunning);
    }

//-only-file header
signals:
    void setRunningStatus(bool status);
    void catChanged(int an, int cat);

private:
    Vtop *dut;
    bool isRunning = false;
    const int INTERVAL = 10000;
    int clockCounter = 0;

    std::map<uint8_t, uint8_t> segmentMap;
    //- {fn}
    uint8_t packSegments()
    //-only-file body
    {
        return  (dut->CA << 0) |
               (dut->CB << 1) |
               (dut->CC << 2) |
               (dut->CD << 3) |
               (dut->CE << 4) |
               (dut->CF << 5) |
               (dut->CG << 6) |
               (dut->DP << 7);
    }


    //- {fn}
    void tick()
    //-only-file body
    {
        while (isRunning)
        {
            dut->CLK100MHZ ^= 1;
            dut->eval();
            clockCounter++;

            uint8_t an = dut->AN;
            uint8_t seg = packSegments();
            auto it = segmentMap.find(an);
            if (it == segmentMap.end()) {
                // First time seeing this AN
                segmentMap[an] = seg;
                emit catChanged(an, seg);
                continue;
            }

            if (it->second != seg) {
                // Value changed
                it->second = seg;
                emit catChanged(an, seg);
                continue;
            }


            if (clockCounter >= INTERVAL)
            {
                clockCounter = 0;
                QCoreApplication::processEvents();
                QThread::yieldCurrentThread();
            }
        }
    }

    //-only-file header
};
