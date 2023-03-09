import random
import copy
import argparse
import cv2 as cv
import csv
import ffmpegcv
import numpy as np
from pathlib import Path
import time
from os import listdir, path, makedirs
from os.path import isfile, join
start = time.time()

# get the source from args
parser = argparse.ArgumentParser()
parser.add_argument('--source', type=str,
                    default='./sourceVideos/toks/download.mp4', help='source')
parser.add_argument('--min_frames', type=int,
                    default=20, help='source')

args = parser.parse_args()
print(args)
# ---


inputName = args.source


currentFolder = Path().cwd()
# path_Csv = str(currentFolder / 'runs/detect/video.mp4/bird-0.csv')
path_Video = str(currentFolder / inputName)

path_Output = str(currentFolder / 'render'/'final' / inputName)

if not path.exists(path_Output):
    makedirs(path_Output)


vidin = ffmpegcv.VideoCaptureNV(path_Video)

dirPath = str(currentFolder / 'runs/detect' / inputName)
files = [f for f in listdir(dirPath) if isfile(join(dirPath, f))]


data = {}
min_frames = args.min_frames

vids = []

for i, fileName in enumerate(files):
    filePath = join(dirPath, fileName)
    file_extension = path.splitext(filePath)[1]

    if file_extension == ".txt":
        continue

    stem = Path(fileName).stem

    with open(filePath, mode='r') as csvfile:
        values = csv.reader(csvfile, delimiter=',')
        rows = 0
        d = []
        coords = [999999, 0, 999999, 0]

        for row in values:
            d.append(row)
            rows += 1

            x1 = min(int(row[1]), coords[0] or int(row[1]))
            x2 = max(int(row[2]), coords[1] or int(row[2]))
            y1 = min(int(row[3]), coords[2] or int(row[3]))
            y2 = max(int(row[4]), coords[3] or int(row[4]))

            coords = [x1, x2, y1, y2]

        csvfile.close()

        # print(values)
        if (rows >= min_frames):
            data[stem] = {rows[0]: [int(rows[1]), int(rows[2]), int(
                rows[3]), int(rows[4])]for rows in d}

            joPath = join(path_Output, stem)

            if not path.exists(joPath):
                makedirs(joPath)

            vids.append([stem, coords])
            # print(stem, 'enough values')
        else:
            print(stem, 'not enough values')


# https://stackoverflow.com/questions/25359288/how-to-know-total-number-of-frame-in-a-file-with-cv2-in-python
def frame_count(video_path, manual=False):
    def manual_count(handler):
        frames = 0
        while True:
            status, frame = handler.read()
            if not status:
                break
            frames += 1
        return frames

    cap = cv.VideoCapture(video_path)
    # Slow, inefficient but 100% accurate method
    if manual:
        frames = manual_count(cap)
    # Fast, efficient but inaccurate method
    else:
        try:
            frames = int(cap.get(cv.CAP_PROP_FRAME_COUNT))
        except:
            frames = manual_count(cap)
    cap.release()
    return frames


TOTAL_FRAMES = frame_count(path_Video)

with vidin:

    frameCount = 0
    for frame in vidin:
        print(frameCount/TOTAL_FRAMES, end="\r")
        removeQueue = []

        for [name, crop_coords] in vids:
            recognitions = data.get(name)

            if (recognitions):
                coordinates = recognitions.get(str(frameCount))
                if (coordinates):

                    x1, x2, y1, y2 = coordinates

                    RGB = np.zeros(frame.shape, dtype="uint8")
                    h, w = RGB.shape[:2]

                    # adding alpha channel
                    # -> make the og frame opaque
                    frameAlpha = np.dstack(
                        (frame, np.zeros((h, w), dtype=np.uint8)+255))
                    # -> make the new frame empty

                    outputFrame = np.dstack(
                        (RGB, np.zeros((h, w), dtype=np.uint8)))

                    outputFrame[y1:y2, x1:x2] = frameAlpha[y1:y2, x1:x2]

                    cx1, cx2, cy1, cy2 = crop_coords
                    cropped_frame = outputFrame[cy1:cy2, cx1:cx2]

                    pad = join(path_Output, name, str(frameCount)) + ".png"

                    cv.imwrite(pad, cropped_frame)

        frameCount += 1


# Grab Currrent Time After Running the Code
end = time.time()

# Subtract Start Time from The End Time
total_time = end - start
print("\n" + str(total_time))
