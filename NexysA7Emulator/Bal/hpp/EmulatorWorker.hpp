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
        : QObject(parent), rgbleds(2)
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

        QTimer *simulationSecond= new QTimer(this);
        simulationSecond->setInterval(5000);
        QObject::connect(simulationSecond, &QTimer::timeout, [=]() {
            emit simulationSecondChanged((tickCounts- previousTickCounts)/5);
            previousTickCounts = tickCounts;
        });
        simulationSecond->start();
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
    void simulationSecondChanged(int i);
    void rgbChanged(int i, int r, int g, int b);

private:
    Vtop *dut;
    bool isRunning = false;
    const int INTERVAL = 10000;
    bool isLedHasChanged = false;
    int tickCounts = 0, previousTickCounts = 0;

    std::vector<uint8_t> segmentVec{8, 0xFF};
    int ledStatus;


    struct DigitUpdate {
        int digit;
        int segments;
    };
    std::vector<DigitUpdate> pendingDigitUpdats;

    class RgbLed {
    public:
        RgbLed() = default;

        int r() const {
            return colorIn255Scale(rHiCount, rTotal);
        }

        int g() const {
            return colorIn255Scale(gHiCount, gTotal);
        }

        int b() const {
            return colorIn255Scale(bHiCount, bTotal);
        }

        void save() {
            rSaved = r();
            gSaved = g();
            bSaved = b();
        }

        void reset() {
            rHiCount = gHiCount = bHiCount = 0;
            rTotal   = gTotal   = bTotal   = 0;
        }

        bool hasChanged() {
            return rSaved != r() ||
                   gSaved != g() ||
                   bSaved != b();
        }

        void addR(bool level) {
            if (level) rHiCount++;
            rTotal++;
        }

        void addG(bool level) {
            if (level) gHiCount++;
            gTotal++;
        }

        void addB(bool level) {
            if (level) bHiCount++;
            bTotal++;
        }

    private:
        int rHiCount = 0;
        int gHiCount = 0;
        int bHiCount = 0;

        int rTotal = 0;
        int gTotal = 0;
        int bTotal = 0;

        int rSaved = 0;
        int gSaved = 0;
        int bSaved = 0;

        int colorIn255Scale(int hi, int total) const {
            if (total == 0)
                return 0;
            return (hi * 255) / total;
        }
    };

    std::vector<RgbLed> rgbleds;


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
        for (int i=0;i<rgbleds.size() ; i++){
            if (rgbleds.at(i).hasChanged()){
                rgbleds.at(i).save();
                emit rgbChanged(i, rgbleds.at(i).r(), rgbleds.at(i).g(), rgbleds.at(i).b());
            }
            rgbleds.at(i).reset();
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

        // has rgb led changed
        rgbleds.at(0).addR(dut->LED16_R);        
        rgbleds.at(0).addG(dut->LED16_G);
        rgbleds.at(0).addB(dut->LED16_B);
        rgbleds.at(1).addR(dut->LED17_R);
        rgbleds.at(1).addG(dut->LED17_G);
        rgbleds.at(1).addB(dut->LED17_B);


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
                tickCounts++;
            }
        }
    }

    //-only-file header
};
