### 添加修改代码，支持TinyPerson/visDronePerson Dataset

代码相关文件的修改与作用如下

function | file | necessary
---| --- | ---
coco格式+ignore的dataset的支持 | + mmdet\datasets\cocofmt.py<br/> > mmdet/datasets/__init__.py| Y
ScaleFactor=1.0的ReSize; | > mmdet/datasets/pipelines/transforms.py:74,99,289| Y
corner| > mmdet/datasets/pipelines/loading.py:64 | X
测试时自动切图| + mmdet/datasets/pipelines/rtest_time_aug.py<br/> > mmdet/datasets/pipelines/__init__.py| X
测试时自动切图|> mmdet/core/bbox/transforms.py:bbox_mapping,bbox_mapping_back<br/> > mmdet/models/dense_heads/dense_test_mixins.py:192<br/>mmdet/core/post_processing/merge_augs.py:69,102|
测试时自动切图|> mmdet/models/detectors/two_stage.py:aug_test+tile_aug_test|
测试时自动切图| > mmdet/models/roi_heads/test_mixins.py:168,323|
do final test| > do_final_eval：mmdet/core/evaluation/eval_hooks.py:10,40 | X
Scale Match| + mmdet/core/bbox/coder/bouding_box.py<br/>+ mmdet/datasets/pipelines/scale_match.py<br/> > mmdet/datasets/pipelines/__init__.py| X
stop while nan| > mmdet/apis/train.py:165,174;<br/> >${config}.py:add check=dict(stop_while_nan=True) | X


上面提到的**coco格式+ignore的dataset的支持**包括：
- coco格式的标注数据的加载;
- 加载标注时处理'ignore'关键字;
- TinyPerson evaluate的支持;
- Location evaluate的支持;
```
evaluate的函数调用链
tools/train.py:train_detector 
-> mmdet/apis/train.py:eval_hook(,**cfg.get('evaluation')) 
-> mmdet/core/evaluation/eval_hooks.py:evaluate
-> mmdet/core/evaluation/eval_hooks.py:dataset.evaluate(
            results, logger=runner.logger, **self.eval_kwargs)
-> mmdet/datasets/cocofmt.py:def evaluate(self,
    …,                
    cocofmt_kwargs={}):
    cocoEval = COCOExpandEval(cocoGt, cocoDt, iou_type, **cocofmt_kwargs)
```
