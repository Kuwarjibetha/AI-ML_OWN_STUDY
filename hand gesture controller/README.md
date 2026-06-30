# Hand Gesture Controller

A simple hand gesture control demo using MediaPipe for hand tracking and OpenCV for camera input.

## Overview

This project tracks a single hand and supports gesture-driven controls for scrolling, volume adjustment, and cursor movement.

## Features

- Hand detection and landmark tracking with `mediapipe`
- Scroll control using two-finger gestures
- Volume control using thumb and index finger distance
- Cursor movement and click actions in a defined on-screen region

## Dependencies

This folder uses Python and the following packages:

- `opencv-python`
- `mediapipe`
- `numpy`
- `pyautogui`
- `comtypes`
- `pycaw`

> Note: `pycaw` and `comtypes` are Windows-specific. Volume control currently works on Windows systems only.

## Installation

Create and activate a virtual environment, then install dependencies:

```bash
python -m venv venv
source venv/bin/activate
pip install opencv-python mediapipe numpy pyautogui comtypes pycaw
```

If you use Windows PowerShell, activate with:

```powershell
venv\Scripts\Activate.ps1
```

## Usage

Run the main script from the project folder:

```bash
cd "hand gesture controller"
python Main.py
```

Press `q` to quit the camera window.

## Files

- `HandTrackingModule.py` — hand detection helper that returns landmark positions.
- `Main.py` — main demo script for gesture recognition and control actions.
- `tempCodeRunnerFile.py` — temporary/test code used during development.

## Notes

- The script uses webcam input with a resolution of 640×480.
- The `Cursor` gesture uses a tracking box and smoothing to reduce jitter.
- On non-Windows systems, camera tracking and cursor movement still work, but audio volume control may not.

## License

This project is provided as-is. Add a license if you want to share it publicly.
