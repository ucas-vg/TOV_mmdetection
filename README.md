## introduction

This project is an [mmdetection](https://github.com/open-mmlab/mmdetection) version of [TinyBenchmark](https://github.com/ucas-vg/TinyBenchmark).

TODO list:

- [x] add TinyPerson dataset and evaluation
- [x] add crop and merge for image during inference
- [x] implement RetinaNet and Faster-FPN baseline on TinyPerson
- [ ] add SM/MSM experiment support
- [ ] add visDronePerson dataset support and baseline performance
- [ ] add point localization task for TinyPerson
- [ ] add point localization task for visDronePerson
- [ ] add point localization task for COCO


## install and setup

download project
```
git clone https://github.com/ucas-vg/TOV_mmdetection --recursive
```

install mmdetection
```
conda create -n open-mmlab python=3.7 -y
conda activate open-mmlab
# install latest pytorch prebuilt with the default prebuilt CUDA version (usually the latest)
conda install -c pytorch pytorch torchvision -y
# conda install -c pytorch pytorch=1.5.0 cudatoolkit=10.2 torchvision -y  # (recommand)
# install the latest mmcv
pip install mmcv-full --user
# install mmdetection

pip uninstall pycocotools
pip install -r requirements/build.txt
pip install -v -e . --user  # or "python setup.py develop"
```

For more detail, please refer [mmdetection install](docs/get_started.md) to install mmdetecion.

## Quickly Start

```
mkdir data
ln -s $Path of TinyPerson$ data/tiny_set

# run experiment, for other config run, see exp/Baseline_TinyPerson.sh
export GPU=4 && LR=02 && CUDA_VISIBLE_DEVICES=0,1,2,3 PORT=10000 tools/dist_train.sh configs2/TinyPerson/base/faster_rcnn_r50_fpn_1x_TinyPerson640.py $GPU \
  --work-dir ../TOV_mmdetection_cache/work_dir/TinyPerson/Base/faster_rcnn_r50_fpn_1x_TinyPerson640/old640x512_lr0${LR}_1x_${GPU}g/ \
  --cfg-options optimizer.lr=0.${LR}
```

#### performance

All train and test on 2080Ti, 
- CUDA10.1/10.2
- python3.7, cudatookit=10.2, pytorch=1.5, torchvision=0.6

for Faster-FPN, we think the gain compare to TinyBenchmark may come 
from the cut and merge during inference running time. 

detector | num_gpu | $AP_{50}^{tiny}$| script
--- | --- | ---| ---
Faster-FPN | 4 | 48.63 | exp/Baseline_TinyPerson.sh:exp1.1
RetainaNet | 1 | | exp/Baseline_TinyPerson.sh:exp2.1
RetainaNet | 4 | | exp/Baseline_TinyPerson.sh:exp2.2(clip grad)