#!/bin/bash

# Train the models with sdm_camus dataset
# Model configs


train_models=("clip_seg" "cris")

dataset="sdm_camus"
prompts=("p0" "p1" "p2" "p3" "p4" "p5" "p6")


# Overwrites of vars
## Pretrained on p6 but fine-tuned on p7
batch_size=32
for model in ${train_models[@]}; do
    for prompt in ${prompts[@]}; do
        experiment_name=${model}_${dataset}_${prompt}
        
        python src/train.py \
            experiment=${model}.yaml \
            experiment_name=${model}_${dataset}_${prompt} \
            datamodule=img_txt_mask_${dataset}.yaml \
            prompt_type=${prompt} \
            datamodule.batch_size=${batch_size} \
            logger.wandb.name=${model}_${prompt} \
            tags="[${model}, ${dataset}, ${prompt}]" \
            output_masks_dir=output_masks/${model}/${dataset}/${prompt} \
            trainer.accelerator=gpu \
            trainer.devices=[0] \
            trainer.precision=16-mixed \
            trainer.max_epochs=2
    done
done
