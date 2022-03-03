# TOV mmdetection
TOV mmdetection is an open source toolbox for object localization and detection tasks on top of mmdetection. 
<!-- To date, TOV mmdetection implements the following algorithms: -->

* [Scale Match for TinyPerson Detection (WACV2020)](docs/tov/)
* [Object Localization under Single Coarse Point Supervision (CVPR2022)](docs/)

# Introduction

TODO list:

- [x] add TinyPerson dataset and evaluation
- [x] add crop and merge for image during inference
- [x] implement RetinaNet and Faster-FPN baseline on TinyPerson
- [x] add SM/MSM experiment support
<!-- - [ ] add visDronePerson dataset support and baseline performance
- [ ] add point localization task for TinyPerson
- [ ] add point localization task for visDronePerson
- [ ] add point localization task for COCO -->


## Install

### [install environment](./docs/install.md>)
```
conda create -n open-mmlab python=3.7 -y
conda activate open-mmlab
# install latest pytorch prebuilt with the default prebuilt CUDA version (usually the latest)
conda install -c pytorch pytorch torchvision -y
# conda install -c pytorch pytorch=1.5.0 cudatoolkit=10.2 torchvision -y
# install the latest mmcv
pip install mmcv-full --user
```

```
conda install scikit-image
```

### download and project setting


- [note]: if your need to modified from origin mmdetection code, see [here](docs/tov/code_modify.md), otherwise do not need any other modified.
- [note]: for more about evaluation, see [evaluation_of_tiny_object.md](docs/tov/evaluation_of_tiny_object.md)

```shell script
git clone https://github.com/ucas-vg/TOV_mmdetection # from github
# git clone https://gitee.com/ucas-vg/TOV_mmdetection  # from gitee
cd TOV_mmdetection
# download code for evaluation
git clone https://github.com/yinglang/huicv/  # from github
# git clone https://gitee.com/ucas-vg/huicv  # from gitee

# install mmdetection
pip uninstall pycocotools   # sometimes need to source deactivate before, for 
pip install -r requirements/build.txt
pip install -v -e . --user  # or try "python setup.py develop" if get still got pycocotools error
```

