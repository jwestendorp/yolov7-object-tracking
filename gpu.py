import cv2
import csv
import ffmpegcv
import numpy as np
from pathlib import Path
import time
start = time.time()


currentFolder = Path().cwd()
path_Csv = str(currentFolder / 'runs/detect/video.mp4/bird-0.csv')
path_Video = str(currentFolder / 'video.mp4')

path_Output = str(currentFolder / 'render/output_ffmpeg3.mp4')


vidin = ffmpegcv.VideoCaptureNV(path_Video)
vidout = ffmpegcv.VideoWriter(path_Output, 'h264', vidin.fps)

d = {}
with open(path_Csv, mode='r') as csvfile:
    values = csv.reader(csvfile, delimiter=',')
    d = {rows[0]: [int(rows[1]), int(rows[2]), int(
        rows[3]), int(rows[4])] for rows in values}


with vidin, vidout:

    frameCount = 0
    for frame in vidin:

        coordinates = d.get(str(frameCount))
        # print(coordinates)

        if (coordinates):
            x1, x2, y1, y2 = coordinates

            outputFrame = np.zeros(frame.shape, dtype="uint8")
            outputFrame[y1:y2, x1:x2] = frame[y1:y2, x1:x2]

            vidout.write(outputFrame)

        frameCount += 1


# Grab Currrent Time After Running the Code
end = time.time()

# Subtract Start Time from The End Time
total_time = end - start
print("\n" + str(total_time))
