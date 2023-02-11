import csv
import cv2
import numpy as np
from pathlib import Path
from utils.datasets import LoadImages
import ffmpegcv
import ffmpeg
from os.path import isfile, join
from os import listdir, path, makedirs

# https://github.com/kkroening/ffmpeg-python/blob/master/examples/read_frame_as_jpeg.py#L16
import argparse

# get the source from args
parser = argparse.ArgumentParser()
parser.add_argument('--source', type=str,
                    default='sourceVideos/vj-tophu/braindead-535.mp4', help='source')

args = parser.parse_args()
print(args)
# ---


inputName = args.source


currentFolder = Path().cwd()

# filePath = str(currentFolder / 'runs' / 'detect' / 'video.mp4' / 'apple-5.csv')
# path_Csv = str(currentFolder / 'runs/detect/video.mp4/bird-0.csv')
# path_Video = str(currentFolder / 'video.mp4')

path_OutputDir = str(currentFolder / 'crop' / inputName)
path_InputDir = str(currentFolder / 'render' / inputName)

# vidin = ffmpegcv.VideoCaptureNV(path_Video)

if not path.exists(path_OutputDir):
    makedirs(path_OutputDir)


path_Csv = str(currentFolder / 'runs/detect' / inputName)
files = [f for f in listdir(path_InputDir) if isfile(join(path_InputDir, f))]


data = {}
outputVideos = {}
min_frames = 5

for i, fileName in enumerate(files):
    stem = Path(fileName).stem
    filePath = join(path_Csv, stem+'.csv')

    data[stem] = [999999, 0, 999999, 0]

    with open(filePath, mode='r') as csvfile:
        values = csv.reader(csvfile, delimiter=',')

        for rows in values:

            x1 = min(int(rows[1]), data[stem][0] or int(rows[1]))
            x2 = max(int(rows[2]), data[stem][1] or int(rows[2]))
            y1 = min(int(rows[3]), data[stem][2] or int(rows[3]))
            y2 = max(int(rows[4]), data[stem][3] or int(rows[4]))

            data[stem] = [x1, x2, y1, y2]


for name, coords in data.items():

    x1, x2, y1, y2 = coords
    inPath = join(path_InputDir, name) + '.mov'
    outPath = join(path_OutputDir, name) + '.mov'

    # print(inPath, outPath, coords)
    (
        ffmpeg.input(inPath).crop(x1, y1, x2-x1, y2-y1).output(outPath).run()
        # ffmpeg.input(inPath).crop(x1, y1, x2-x1, y2 -
        #                           y1).output(outPath, vcodec='v410').run()
    )


# if __name__ == '__main__':
#     parser = argparse.ArgumentParser()
