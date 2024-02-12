export MS2_ASSET_DIR=./ManiSkill2_real2sim/data

gpu_id=0

declare -a policy_models=(
  ./checkpoints/octo_feb1_24/octo_base_gpu_final
)

# declare -a policy_models=(
# "octo-base"
# "octo-small"
# )

# lr_switch=laying horizontally but flipped left-right to match real eval; upright=standing; laid_vertically=laying vertically                
declare -a coke_can_options_arr=("lr_switch=True" "upright=True" "laid_vertically=True") 

env_name=GraspSingleOpenedCokeCanInScene-v0
scene_name=google_pick_coke_can_1_v4
rgb_overlay_path=./ManiSkill2_real2sim/data/real_impainting/google_coke_can_real_eval_1.png

for ckpt_path in "${arr[@]}"; do echo "$ckpt_path"; done


for policy_model in "${policy_models[@]}";

do for coke_can_option in "${coke_can_options_arr[@]}";

do CUDA_VISIBLE_DEVICES=${gpu_id} python real2sim/main_inference.py --policy-model ${policy_model} --ckpt-path None \
  --robot google_robot_static  --policy-setup google_robot \
  --control-freq 3 --sim-freq 501 --max-episode-steps 80 \
  --env-name ${env_name} --scene-name ${scene_name} \
  --rgb-overlay-path ${rgb_overlay_path} \
  --robot-init-x 0.35 0.35 1 --robot-init-y 0.20 0.20 1 --obj-init-x -0.35 -0.12 5 --obj-init-y -0.02 0.42 5 \
  --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 \
  --additional-env-build-kwargs ${coke_can_option};

done

done
