# Hand Gesture Controller

This repository contains a hand gesture controller demo located in the `hand gesture controller/` folder.

## Overview

The demo uses MediaPipe to detect hand landmarks in webcam video and converts gestures into control actions such as scrolling, cursor movement, and volume adjustment.

## Supported Features

- Hand detection and landmark tracking with `mediapipe`
- Scroll gestures using two or three fingers
- Volume control using thumb and index finger distance
- Cursor movement and click actions with hand position

## Dependencies

Install the required packages:

```bash
pip install opencv-python mediapipe numpy pyautogui comtypes pycaw
```

> Note: `pycaw` and `comtypes` are Windows-specific. Volume control works on Windows only. The webcam tracking and cursor movement still function on macOS, but audio control is not supported outside Windows.

## Installation

Create and activate a virtual environment, then install dependencies:

```bash
python -m venv venv
source venv/bin/activate
pip install opencv-python mediapipe numpy pyautogui comtypes pycaw
```

On Windows PowerShell, activate with:

```powershell
venv\Scripts\Activate.ps1
```

## Usage

Run the demo from the hand gesture controller folder:

```bash
cd "hand gesture controller"
python Main.py
```

Press `q` to exit the camera window.

## Project Files

- `hand gesture controller/HandTrackingModule.py` — helper module for hand landmark detection.
- `hand gesture controller/Main.py` — main application script for gesture recognition and control.
- `hand gesture controller/tempCodeRunnerFile.py` — temporary development/test script.

## Notes

- The demo uses a 640×480 webcam feed by default.
- If the camera does not open, verify your webcam permissions and that the correct camera index is selected.
- If performance is slow, lower the resolution or close other applications.

## License

This project is provided as-is. Add a license file if you want to publish or share the code.
