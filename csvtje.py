import csv
import cv2
import numpy as np
from pathlib import Path
from utils.datasets import LoadImages
from os import listdir
from os.path import isfile, join
import argparse

# get the source from args
parser = argparse.ArgumentParser()
parser.add_argument('--source', type=str,
                    default='runs/detect/video.mp4', help='source')

args = parser.parse_args()
print(args)
# ---

currentFolder = Path().cwd()

dirPath = str(currentFolder /
              'runs/detect' / args.source)
files = [f for f in listdir(dirPath) if (
    isfile(join(dirPath, f)) and
    f.split('.')[-1] == 'csv'
)]


# print(files[0])

d = {}
for i, fileName in enumerate(files):
    filePath = join(dirPath, fileName)
    stem = Path(fileName).stem

    with open(filePath, mode='r') as csvfile:
        values = csv.reader(csvfile, delimiter=',')
        # print(stem, len(list(values)))
        d[stem] = {rows[0]: [rows[1], rows[2], rows[3], rows[4]]
                   for rows in values}


for key, values in d.items():
    print(key)

# for i in range(1, 999):

#     for name, recognition in d.items():
#         frame = recognition.get(str(i))
#         if frame:
#             x1, x2, y1, y2 = frame
#             print(i, name, x1, x2, y1, y2)
