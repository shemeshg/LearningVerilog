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
        QTimer *tickTimer = new QTimer(this);
        tickTimer->setInterval(0);
        connect(tickTimer, &QTimer::timeout, this, &EmulatorWorker::tick);
        tickTimer->start();

        QTimer *sampleTimer = new QTimer(this);
        sampleTimer->setInterval(40); // 40 ms GUI update
        connect(sampleTimer, &QTimer::timeout, this, &EmulatorWorker::sampleOutputs);
        sampleTimer->start();
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
        // qDebug() << "DUT started";
        //  Reset
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
        // qDebug() << "DUT stoped";
        emit setRunningStatus(isRunning);
    }

    //-only-file header
signals:
    void setRunningStatus(bool status);
    void catChanged(int an, int cat);
    void ledChanged(int led);

private:
    Vtop *dut;
    bool isRunning = false;
    const int INTERVAL = 10000;
    bool isLedHasChanged = false;

    std::vector<uint8_t> segmentVec{8, 0xFF};
    int ledStatus;


    struct DigitUpdate {
        int digit;
        int segments;
    };
    std::vector<DigitUpdate> pendingDigitUpdats;

    //- {fn}
    uint8_t packSegments()
    //-only-file body
    {
        return (dut->CA << 0) |
               (dut->CB << 1) |
               (dut->CC << 2) |
               (dut->CD << 3) |
               (dut->CE << 4) |
               (dut->CF << 5) |
               (dut->CG << 6) |
               (dut->DP << 7);
    }

    //- {fn}
    void sampleOutputs()
    //-only-file body
    {
        if (isLedHasChanged){
            emit ledChanged(ledStatus);
            isLedHasChanged = false;
        }

        if (!pendingDigitUpdats.empty()) {
            for (const auto& upd : pendingDigitUpdats) {
                emit catChanged(upd.digit, upd.segments);
            }
            pendingDigitUpdats.clear();
        }
    }

    //- {fn}
    void identifyChangesOnTick()
    //-only-file body
    {
        uint8_t an_raw = dut->AN;
        uint8_t an = ~an_raw & 0xFF;  // convert active-low AN → active-high
        uint8_t seg = packSegments(); // already inverted inside

        if (ledStatus!=dut->LED){
            ledStatus = dut->LED;
            isLedHasChanged = true;
        }
        // Decode which digit is active (0–7)
        int digit = -1;
        for (int i = 0; i < 8; i++)
        {
            if (an & (1 << i))
            {
                digit = i;
                break;
            }
        }

        if (digit >= 0)
        {
            if (segmentVec[digit-1] != seg)
            {
                segmentVec[digit-1] = seg;
                pendingDigitUpdats.push_back({an, seg});
            }
        }
    }


    //- {fn}
    void tick()
    //-only-file body
    {
        if (isRunning)
        {
            for (int clockCounter = 0;clockCounter<=INTERVAL;clockCounter++){
                dut->CLK100MHZ ^= 1;
                dut->eval();
                identifyChangesOnTick();
            }
        }
    }

    //-only-file header
};
