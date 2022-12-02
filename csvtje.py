import csv
import cv2
import numpy as np
from pathlib import Path
from utils.datasets import LoadImages


currentFolder = Path().cwd()

# filePath = str(currentFolder / 'runs' / 'detect' / 'video.mp4' / 'apple-5.csv')
filePath = str(currentFolder / 'runs/detect/video.mp4/bird-0.csv')


# ret, frame = video.read()

d = {}
with open(filePath, mode='r') as csvfile:
    values = csv.reader(csvfile, delimiter=',')
    d = {rows[0]: [rows[1], rows[2], rows[3], rows[4]] for rows in values}


for i in range(1, 999):
    frame = d.get(str(i))
    if frame:
        x1, x2, y1, y2 = frame
        print(i, x1, x2, y1, y2)
