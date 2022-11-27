import csv
import cv2
import numpy as np
from pathlib import Path
from utils.datasets import LoadImages


currentFolder = Path().cwd()

# filePath = str(currentFolder / 'runs' / 'detect' / 'video.mp4' / 'apple-5.csv')
filePath = str(currentFolder / 'runs/detect/video.mp4/apple-5.csv')
videoSrc = str(currentFolder / 'video.mp4')
video = cv2.VideoCapture('video.mp4')


# while video.isOpened():
#     ret, frame = video.read()
#     # if frame is read correctly ret is True
#     if not ret:
#         print("Can't receive frame (stream end?). Exiting ...")
#         break
#     cv2.imshow('frame', frame)
#     if cv2.waitKey(1) == ord('q'):
#         break
# video.release()
# cv2.destroyAllWindows()

with open(filePath, newline='') as csvfile:
    rows = csv.reader(csvfile, delimiter=',')
    data = []
    for row in rows:
        # data.append(row)
        frameNr = int(row[0])
        x = float(row[1])
        y = float(row[2])
        w = float(row[3])
        h = float(row[4])

        video.set(cv2.CAP_PROP_POS_FRAMES, frameNr)
        ret, frame = video.read()

        outputFrame = np.zeros(frame.shape, dtype="uint8")

        y_res = frame.shape[0]
        x_res = frame.shape[1]

        print(x_res, y_res)

        width = w * x_res
        height = h * y_res

        y1 =
        y2 =
        x1 =
        x2 =

        outputFrame[y1:y2, x1:x2] = frame[y1:y2, x1:x2]

        cv2.imshow('frame', frame)
        cv2.waitKey(1)

video.release()
cv2.destroyAllWindows()
