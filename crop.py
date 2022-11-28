import csv
import cv2
import numpy as np
from pathlib import Path
from utils.datasets import LoadImages


currentFolder = Path().cwd()

# filePath = str(currentFolder / 'runs' / 'detect' / 'video.mp4' / 'apple-5.csv')
filePath = str(currentFolder / 'runs/detect/video.mp4/bird-0.csv')
videoSrc = str(currentFolder / 'video.mp4')
video = cv2.VideoCapture('video.mp4')

save_path = str(currentFolder / 'render/output.mp4')

vid_path, vid_writer = None, None

fps = video.get(cv2.CAP_PROP_FPS)
w = int(video.get(cv2.CAP_PROP_FRAME_WIDTH))
h = int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))

vid_writer = cv2.VideoWriter(
    save_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (w, h))
# vid_writer = cv2.VideoWriter(
#     save_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (w, h))

with open(filePath, newline='') as csvfile:
    values = csv.reader(csvfile, delimiter=',')
    data = []
    rows = list(values)
    for i, row in enumerate(rows):
        # data.append(row)
        frameNr = int(row[0])
        x1 = int(row[1])
        x2 = int(row[2])
        y1 = int(row[3])
        y2 = int(row[4])

        video.set(cv2.CAP_PROP_POS_FRAMES, frameNr)
        ret, frame = video.read()

        outputFrame = np.zeros(frame.shape, dtype="uint8")
        outputFrame[y1:y2, x1:x2] = frame[y1:y2, x1:x2]

        # cv2.imshow('frame', outputFrame)
        vid_writer.write(outputFrame)
        # cv2.waitKey(1)
        print(i, '/', len(rows)-1)

# video.release()
# cv2.destroyAllWindows()
