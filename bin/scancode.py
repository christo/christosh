#!/usr/bin/env python3

import keyboard

def on_key_event(event):
    print(f"Key: {event.name}, Scancode: {event.scan_code}")

keyboard.hook(on_key_event)
keyboard.wait()  # Wait indefinitely
