import time
import board
import digitalio
import usb_hid
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keycode import Keycode

key_pins = [
    board.A1, # FULL ON
    board.A2, # STAND BY
    board.A3, # PATTERN UP
    board.A4  # STEP UP
]

key_binds = [
    # Unclutched
    [Keycode.F13],
    [Keycode.F14],
    [Keycode.F15],
    # Clutched
    [Keycode.F16],
    [Keycode.F17],
    [Keycode.F18],
]

# Initialize keyboard
time.sleep(1)
keyboard = Keyboard(usb_hid.devices)

# Setup all input pins
key_pin_array = []
for pin in key_pins:
    key_pin = digitalio.DigitalInOut(pin)
    key_pin.direction = digitalio.Direction.INPUT
    key_pin.pull = digitalio.Pull.UP
    key_pin_array.append(key_pin)

# Setup LED
led = digitalio.DigitalInOut(board.D13)
led.direction = digitalio.Direction.OUTPUT

# First pedal is clutch
clutch = key_pin_array.pop(0)

while True:
    # Check for clutch each loop
    clutched = False
    if not clutch.value:
        clutched = True

    # Check each other pedal
    for key_pin in key_pin_array:
        if not key_pin.value:
            led.value = True
            i = key_pin_array.index(key_pin)

            # Get clutched or unclutched key binds
            key = key_binds[i+3] if clutched else key_binds[i]
            # Send keys; asterisk deconstructs array into seperate arguments
            keyboard.press(*key)

            # Wait for the pedal to be released
            while not key_pin.value:
                pass

            # Release all keys
            keyboard.release_all()
            led.value = False
    time.sleep(0.01)