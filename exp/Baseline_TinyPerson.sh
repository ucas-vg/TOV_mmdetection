
# exp1.1: Faster-FPN
export GPU=4 && LR=02 && CUDA_VISIBLE_DEVICES=4,5,6,7 PORT=10000 tools/dist_train.sh configs2/TinyPerson/base/faster_rcnn_r50_fpn_1x_TinyPerson640.py $GPU \
  --work-dir ../TOV_mmdetection_cache/work_dir/TinyPerson/Base/faster_rcnn_r50_fpn_1x_TinyPerson640/old640x512_lr0${LR}_1x_${GPU}g/ \
  --cfg-options optimizer.lr=0.${LR}

# exp2.1: RetinaNet
export GPU=1 && LR=005 && CUDA_VISIBLE_DEVICES=4 PORT=10000 tools/dist_train.sh configs2/TinyPerson/base/retinanet_r50_fpns4_1x_TinyPerson640.py $GPU \
  --work-dir ../TOV_mmdetection_cache/work_dir/TinyPerson/Base/retinanet_r50_fpns4_1x_TinyPerson640/old640x512_lr0${LR}_1x_${GPU}g/ \
  --cfg-options optimizer.lr=0.${LR}
# # exp2.2: 4gpu clip grad
export GPU=4 && LR=02 && CUDA_VISIBLE_DEVICES=4,5,6,7 PORT=10000 tools/dist_train.sh configs2/TinyPerson/base/retinanet_r50_fpns4_1x_TinyPerson640_cilpg.py $GPU \
  --work-dir ../TOV_mmdetection_cache/work_dir/TinyPerson/Base/retinanet_r50_fpns4_1x_TinyPerson640/old640x512_lr0${LR}_1x_clipg_${GPU}g/  \
  --cfg-options optimizer.lr=0.${LR}




