import cv2
import csv
import ffmpegcv
import numpy as np
from pathlib import Path
import time
from os import listdir
from os.path import isfile, join
start = time.time()


currentFolder = Path().cwd()
path_Csv = str(currentFolder / 'runs/detect/video.mp4/bird-0.csv')
path_Video = str(currentFolder / 'video.mp4')

path_Output = str(currentFolder / 'render/video.mp4/')


vidin = ffmpegcv.VideoCaptureNV(path_Video)
# vidout = ffmpegcv.VideoWriter(path_Output, 'h264', vidin.fps)

currentFolder = Path().cwd()

dirPath = str(currentFolder / 'runs/detect/video.mp4')
files = [f for f in listdir(dirPath) if isfile(join(dirPath, f))]


data = {}
outputVideos = {}
MINIMUM_FRAMES = 5

for i, fileName in enumerate(files):
    filePath = join(dirPath, fileName)
    stem = Path(fileName).stem

    with open(filePath, mode='r') as csvfile:
        values = csv.reader(csvfile, delimiter=',')

        # if (len(list(values)) >= MINIMUM_FRAMES):
        data[stem] = {rows[0]: [int(rows[1]), int(rows[2]), int(rows[3]), int(rows[4])]
                      for rows in values}

        joPath = join(path_Output, stem) + '.mp4'

        outputVideos[stem] = ffmpegcv.VideoWriter(
            joPath, 'h264', vidin.fps)
        # else:
        #     print(stem, 'not enough values')

with vidin:

    frameCount = 0
    for frame in vidin:
        print(frameCount)

        for name, recognitions in data.items():
            # print(recognitions)
            # coordinates = False
            coordinates = recognitions.get(str(frameCount))
            if (coordinates):

                x1, x2, y1, y2 = coordinates

                outputFrame = np.zeros(frame.shape, dtype="uint8")
                outputFrame[y1:y2, x1:x2] = frame[y1:y2, x1:x2]

                outputVideos[name].write(outputFrame)
                # print(outputVideos[name])
            # else:
                # print(frameCount, 'no coordinates')
        frameCount += 1


# Grab Currrent Time After Running the Code
end = time.time()

# Subtract Start Time from The End Time
total_time = end - start
print("\n" + str(total_time))
