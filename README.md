# Chauvet Stage Designer 16 Foot Pedal USB Macro Pad

This is a simple project to create an adapter that turns a Chauvet Stage
Designer 16 foot pedal into a USB macro foot switch.

The foot pedal is a very simple device. It has four spring-loaded pedals over
a PCB with four momentary switches. The PCB connects to a standard male DB-9
D-SUB connector. It uses pin 5 as a common line for the switches, and pins
1-4 as the signal pins for the switches.

A [DB-9 "motherboard" connector](https://www.amazon.com/gp/product/B0067DB6RU)
can be used as a simple adapter, because it breaks out the DB-9 pins to a
standard 2x5 pin IDC header; which can be easily connected to a microcontroller.

This project uses the [Adafruit Feather M0 Express](https://www.adafruit.com/product/3403)
microcontroller because it has USB HID support, intigrated pullup resisters,
and a nice proto perf board area to mount a 2x5 socket for the DB-9 adapter.

## Pinout Diagram

```
  DB-9 Male          IDC Header
                        ┌─┐
┌───────────┐      ┌────┴─┴─ ──┐
│ 1 2 3 4 5 │ ───► │ 1 2 5 8 9 │
│  6 7 8 9  │      │ 3 6 4 7 X │
└───────────┘      └───────────┘

  Connection        DB-9   Pin
  ────────────────────────────
  Ground            5      GND
  P1 (FULL ON)      4      A1
  P2 (STAND BY)     3      A2
  P3 (PATTERN UP)   2      A3
  P4 (STEP UP)      1      A4
```

## References
* [Feather Specification](https://learn.adafruit.com/adafruit-feather/feather-specification)
* [Feather M0 Express Reference](https://learn.adafruit.com/adafruit-feather-m0-basic-proto/overview)
* [Feather M0 Express CAD Model](https://github.com/adafruit/Adafruit_CAD_Parts/blob/master/3403%20Feather%20M0%20Express/3403%20Feather%20M0%20Express.stl)
* [CircuitPython Getting Started Guide](https://learn.adafruit.com/welcome-to-circuitpython)
* [Adafruit HID Library Documentation](https://circuitpython.readthedocs.io/projects/hid/en/latest/)
* [circup](https://github.com/adafruit/circup)

## Attributions
* Enclosure design is based on Heartman's [OpenScad Parametric Box](https://www.thingiverse.com/thing:1264391) [CC BY-NC 3.0 License]