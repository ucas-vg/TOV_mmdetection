# Introduction

TODO list:

- [x] add TinyPerson dataset and evaluation
- [x] add crop and merge for image during inference
- [x] implement RetinaNet and Faster-FPN baseline on TinyPerson
- [x] add SM/MSM experiment support
- [ ] add visDronePerson dataset support and baseline performance
- [ ] add point localization task for TinyPerson
- [ ] add point localization task for visDronePerson
- [ ] add point localization task for COCO

# Prerequisites

### [install mmdetection](./docs/install.md>)
```
conda create -n open-mmlab python=3.7 -y
conda activate open-mmlab
# install latest pytorch prebuilt with the default prebuilt CUDA version (usually the latest)
conda install -c pytorch pytorch torchvision -y
# conda install -c pytorch pytorch=1.5.0 cudatoolkit=10.2 torchvision -y
# install the latest mmcv
pip install mmcv-full --user
# install mmdetection

pip uninstall pycocotools   # sometimes need to source deactivate before, for 
pip install -r requirements/build.txt
pip install -v -e . --user  # or try "python setup.py develop" if get still got pycocotools error
```

```
conda install scikit-image
```

[note]: if your need to modified from origin mmdetection code, see [here](exp/doc/code_modify.md), otherwise do not need any other modified.

### prepare dataset
#### TinyPerson

to train baseline of TinyPerson, download the mini_annotation of all annotation is enough, 
which can be downloaded as tiny_set/mini_annotations.tar.gz in [Baidu Yun(password:pmcq) ](https://pan.baidu.com/s/1kkugS6y2vT4IrmEV_2wtmQ)/
[Google Driver](https://drive.google.com/open?id=1KrH9uEC9q4RdKJz-k34Q6v5hRewU5HOw).

```
mkdir data
ln -s ${Path_Of_TinyPerson} data/tiny_set
tar -zxvf data/tiny_set/mini_annotations.tar.gz && mv mini_annotations data/tiny_set/
```

#### COCO

```
ln -s ${Path_Of_COCO} data/coco
```


#### download project

```shell script

git clone https://gitee.com/ucas-vg/TOV_mmdetection # git clone https://github.com/ucas-vg/TOV_mmdetection
cd TOV_mmdetection
# download code for evaluation
git clone https://gitee.com/ucas-vg/huicv # git clone https://github.com/yinglang/huicv/
```

# Experiment
## TinyPerson

For running more experiment, to see [bash script](exp/sh/Baseline_TinyPerson.sh)

```shell script
# exp1.2: Faster-FPN, 2GPU
export GPU=2 && LR=0.01 && CUDA_VISIBLE_DEVICES=0,1 PORT=10000 tools/dist_train.sh configs2/TinyPerson/base/faster_rcnn_r50_fpn_1x_TinyPerson640.py $GPU \
  --work-dir ../TOV_mmdetection_cache/work_dir/TinyPerson/Base/faster_rcnn_r50_fpn_1x_TinyPerson640/old640x512_lr${LR}_1x_${GPU}g/ \
  --cfg-options optimizer.lr=${LR}

# Scale Match
# exp4.0 coco-sm-tinyperson: Faster-FPN, coco batch=8x2
export GPU=2 && export LR=0.01 && export BATCH=8 && export CONFIG="faster_rcnn_r50_fpn_1x_coco_sm_tinyperson"
export COCO_WORK_DIR="../TOV_mmdetection_cache/work_dir/TinyPerson/scale_match/${CONFIG}/lr${LR}_1x_${BATCH}b${GPU}g/"
CUDA_VISIBLE_DEVICES=0,1 PORT=10001 tools/dist_train.sh configs2/TinyPerson/scale_match/${CONFIG}.py $GPU \
  --work-dir ${COCO_WORK_DIR} --cfg-options optimizer.lr=${LR} data.samples_per_gpu=${BATCH}
# python exp/tools/extract_weight.py ${COCO_WORK_DIR}/latest.pth
export TCONFIG="faster_rcnn_r50_fpn_1x_TinyPerson640"
export GPU=2 && LR=0.01 && CUDA_VISIBLE_DEVICES=0,1 PORT=10000 tools/dist_train.sh configs2/TinyPerson/base/${TCONFIG}.py $GPU \
  --work-dir ../TOV_mmdetection_cache/work_dir/TinyPerson/scale_match/${TCONFIG}/cocosm_old640x512_lr${LR}_1x_${GPU}g/ \
  --cfg-options optimizer.lr=${LR} load_from=${COCO_WORK_DIR}/latest.pth
```

- GPU: 3080 x 2
- Adap RetainaNet-c means use clip grad while training.
- COCO val $mmap$ only use for debug, cause val also add to train while sm/msm coco to TinyPerson

detector | type | $AP_{50}^{tiny}$| script | COCO200 val $mmap$ | coco batch/lr
--- | --- | ---| ---| ---| ---
Faster-FPN | - |  47.90 | exp/sh/Baseline_TinyPerson.sh:exp1.2 | - | -
Faster-FPN | SM | 50.06 | exp/sh/Baseline_TinyPerson.sh:exp4.0 | 18.9 | 8x2/0.01
Faster-FPN | SM | 49.53 | exp/sh/Baseline_TinyPerson.sh:exp4.1 | 18.5 | 4x2/0.01
Faster-FPN | MSM | 49.39 | exp/sh/Baseline_TinyPerson.sh:exp4.2 | 12.1 | 4x2/0.01
--| --| --
Adap RetainaNet-c | - | 43.66 | exp/sh/Baseline_TinyPerson.sh:exp2.3 | - | -
Adap RetainaNet-c | SM | 50.07 | exp/sh/Baseline_TinyPerson.sh:exp5.1 | 19.6 | 4x2/0.01
Adap RetainaNet-c | MSM | 48.39 | exp/sh/Baseline_TinyPerson.sh:exp5.2 | 12.9 | 4x2/0.01

for more experiment, to see [TinyPerson experiment](exp/doc/TinyPerson.md)
for detail of scale match, to see [TinyPerson Scale Match](exp/doc/TinyPerson/ScaleMatch.md)

