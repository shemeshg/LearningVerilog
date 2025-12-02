# LetsGetSerial

A lightweight, extensible Qt QML-based serial terminal and graphing app designed for Arduino projects. 
LetsGetSerial provides a clean foundation for developers to build custom interfaces, 
visualize data, and interact with their microcontrollers.

## Arduino serial example

[./ArdionoShellWe/ShellWe/Shellwe.uno](https://github.com/shemeshg/LetsGetSerial/blob/main/ArduinoShellWe/ShellWe/ShellWe.ino)

```text
Available commands:
? - help
STATUS
ECHO <int bool>
pinMode int <OUTPUT|INPUT|INPUT_PULLUP>
digitalWrite int <HIGH|LOW>
analogWrite int <int 1..255>
digitalRead int 
analogRead int 
followMode int int int - <pin> <0/1 to follow input> <followAnalogTolerance>  <int millis interval 0=false>
heartbeat <int heartbeatIntervalCounter start 0=false> <int millis interval>
```

For example
```
pinMode 14 INPUT
analogRead 14
followMode 14 1 4 100
```

## Playground scatch window

https://github.com/shemeshg/LetsGetSerial/blob/main/Design/Playground/PlaygroundComponent.qml

<img width="410" height="474" alt="image" src="https://github.com/user-attachments/assets/5fc4ad08-cc1f-4ee1-9ae0-da809400ec27" />




<img width="729" height="535" alt="image" src="https://github.com/user-attachments/assets/a352e83b-9cde-4029-942e-9a2cc1356cb7" />
