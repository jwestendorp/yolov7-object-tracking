## crop

- start the terminal in venv

1. Generate the csv files (yeah it says json):

```
python detect_and_track_JSON.py --source "./sourceVideos/vj-tophu/braindead-535.mp4"
```

-> this will put data in `./runs/detect/sourceVideos/...etc`

2. render them

```
python gpu.py --source "sourceVideos/vj-tophu/braindead-535.mp4"
```

3. crop them

```
python crop-ffmpeg.py --source "./sourceVideos/vj-tophu/${file.name}
```

---

## markov

create a `chain.txt`:

```
# put a source from crop.1
python csvtje.py --source "sourceVideos/vj-tophu/braindead-535.mp4"
```
