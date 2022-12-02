import csv
import cv2
import numpy as np
from pathlib import Path
from utils.datasets import LoadImages
import ffmpeg


# https://github.com/kkroening/ffmpeg-python/blob/master/examples/read_frame_as_jpeg.py#L16

currentFolder = Path().cwd()

# filePath = str(currentFolder / 'runs' / 'detect' / 'video.mp4' / 'apple-5.csv')
path_Csv = str(currentFolder / 'runs/detect/video.mp4/bird-0.csv')
path_Video = str(currentFolder / 'video.mp4')

path_Output = str(currentFolder / 'render/output_ffmpeg%03d.jpg')

vid_path, vid_writer = None, None

(
    ffmpeg
    .input(path_Video)
    .filter('select', "eq(n,1)+eq(n,99)")
    .crop(10, 100, 200, 200)
    .output(path_Output, vsync=0)
    .run()
)
