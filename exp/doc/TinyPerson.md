# TinyPerson

- [Scale Match Experiment](TinyPerson/ScaleMatch.md)
- [Coarse Point Experiment](TinyPerson/CoarsePoint.md)


### 1 配置文件
配置dataset和mini_annotations

config相关文件的添加,修改涉及
- _base_里的dataset
- num_class/max_per_img in test
- anchor scales
- fix BN requires_grad=False in Backbone (learnable BN/GN is hard for TinyPerson??)

```
# dataset
configs2/_base_/datasets/TinyPerson/TinyPerson_detection_640x512.py

# Faster-FPN
configs2\TinyPerson\base\faster_rcnn_r50_fpn_1x_TinyPerson640.py

# RetinaNet
configs2/TinyPerson/base/retinanet_r50_fpn_1x_TinyPerson640.py
configs2/TinyPerson/base/retinanet_r50_fpns4_1x_TinyPerson640.py
configs2/TinyPerson/base/retinanet_r50_fpns4_1x_TinyPerson640_clipg.py
```

### 2. performance

All train and test on 2080Ti, 
- CUDA10.1/10.2
- python3.7, cudatookit=10.2, pytorch=1.5, torchvision=0.6

for Faster-FPN, we think the gain compare to TinyBenchmark may come 
from the cut and merge during inference running time. 

detector | num_gpu | $AP_{50}^{tiny}$| script
--- | --- | ---| ---
Faster-FPN | 4 | 48.27(2) | exp/sh/Baseline_TinyPerson.sh:exp1.1
Adap RetainaNet | 1 | 43.80(2) | exp/sh/Baseline_TinyPerson.sh:exp2.1
Adap RetainaNet | 4 | 44.94(1) | exp/sh/Baseline_TinyPerson.sh:exp2.2(clip grad)

Following are run on 3080 x2

detector | norm_grad | $AP_{50}^{tiny}$| script
--- | --- | ---| ---
RepPoint w/o GN Neck| N | 37.16 | exp/sh/Baseline_TinyPerson.sh:3.1
RepPoint w/o GN Neck| Y | nan | exp/sh/Baseline_TinyPerson.sh:3.2
Adap RepPoint w/o GN Neck| N | nan | exp/sh/Baseline_TinyPerson.sh:3.3
RepPoint | Y | 28.53 | exp/sh/Baseline_TinyPerson.sh:3.4
RepPoint | N | 29.84 | exp/sh/Baseline_TinyPerson.sh:3.6
Adap RepPoint | Y | 44.58 | exp/sh/Baseline_TinyPerson.sh:3.5