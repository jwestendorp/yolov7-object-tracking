import cv2
import csv
import ffmpegcv
import numpy as np
from pathlib import Path
import time
from os import listdir
from os.path import isfile, join
start = time.time()

inputName = "sourceVideos/download (3).mp4"


currentFolder = Path().cwd()
# path_Csv = str(currentFolder / 'runs/detect/video.mp4/bird-0.csv')
path_Video = str(currentFolder / inputName)

path_Output = str(currentFolder / 'render' / inputName)


vidin = ffmpegcv.VideoCaptureNV(path_Video)
# vidout = ffmpegcv.VideoWriter(path_Output, 'h264', vidin.fps)


dirPath = str(currentFolder / 'runs/detect' / inputName)
files = [f for f in listdir(dirPath) if isfile(join(dirPath, f))]


data = {}
outputVideos = {}
min_frames = 10

for i, fileName in enumerate(files):
    filePath = join(dirPath, fileName)
    stem = Path(fileName).stem

    with open(filePath, mode='r') as csvfile:
        values = csv.reader(csvfile, delimiter=',')
        rows = 0
        d = []
        for row in values:
            d.append(row)
            rows += 1
        csvfile.close()

        # print(values)
        if (rows >= min_frames):
            data[stem] = {rows[0]: [int(rows[1]), int(rows[2]), int(
                rows[3]), int(rows[4])]for rows in d}

            joPath = join(path_Output, stem) + '.mp4'
            outputVideos[stem] = ffmpegcv.VideoWriter(
                joPath, None, vidin.fps)
        else:
            print(stem, 'not enough values')


with vidin:

    frameCount = 0
    for frame in vidin:

        removeQueue = []

        for name in outputVideos.keys():
            recognitions = data.get(name)

            if (recognitions):

                coordinates = recognitions.get(str(frameCount))
                if (coordinates):
                    # print(frameCount, name, coordinates)
                    # coordinates = False
                    x1, x2, y1, y2 = coordinates

                    outputFrame = np.zeros(frame.shape, dtype="uint8")
                    outputFrame[y1:y2, x1:x2] = frame[y1:y2, x1:x2]

                    outputVideos[name].write(outputFrame)
                    lastFrame = int(list(recognitions.keys())[-1])

                    if lastFrame <= frameCount:
                        print('removing', name)
                        outputVideos[name].release()
                        removeQueue.append(name)

        frameCount += 1
        for name in removeQueue:
            del outputVideos[name]
            print(len(list(outputVideos.keys())))


# Grab Currrent Time After Running the Code
end = time.time()

# Subtract Start Time from The End Time
total_time = end - start
print("\n" + str(total_time))
