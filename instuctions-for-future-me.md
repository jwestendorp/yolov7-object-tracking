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

create a `chain.json`:

```
node chainJson.mjs "./runs/detect/sourceVideos/vj-tophu/high-998.mp4/chain.txt"
```

use ./markov/mergeJson.js to merge json chain files

create a  stats file
```
node statsJson.mjs "./runs/detect/sourceVideos/vj-tophu/high-998.mp4/
```

<!-- ```
# put a source from crop.1
python csvtje.py --source "sourceVideos/vj-tophu/braindead-535.mp4"
``` -->

## scene detect
create cuts
```
 bash scene-detect.sh -i high.mp4 -t 0.2 -o gocuts.txt
 ```

convert the cutlist
 ```
 bash scene-time.sh -i mensiscuts.txt -o mensisCutlist.txt
 ```

 crop
 ```
 bash scene-cut.sh -i TophuGo.mp4 -c gocutlist.txt -x 1
 ```
 -x can be used to change the startIndex