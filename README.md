# Hand Gesture Controller

Lightweight hand gesture controller using a hand-tracking module.

## Overview

This project demonstrates a simple setup for tracking hand landmarks and using them to interpret gestures. The repository contains a hand tracking module and a small runner to start the demo.

## Prerequisites

- Python 3.8 or newer
- A webcam

## Dependencies

Install required packages with pip:

```bash
pip install opencv-python mediapipe numpy
```

Or using a virtual environment:

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Usage

Run the main script to start the hand tracking demo:

```bash
python "Main.py"
```

If your system uses a different camera index, update the camera argument inside `Main.py` accordingly.

## Files

- `HandTrackingModule.py`: Hand-tracking helper (landmark detection and utilities).
- `Main.py`: Entry point to run the demo.
- `tempCodeRunnerFile.py`: Temporary/test code used during development.

## Notes

- If you see performance issues, try lowering the camera resolution or running on a machine with hardware acceleration.
- macOS users may need to grant Camera permissions to the terminal/IDE.

## License

This project is provided as-is. Add a license file if you intend to share it publicly.

## Contact

Questions or improvements: update the repo or open an issue.
