#! /bin/bash

input_folder='examples/';
output_folder='output/';
model_file='vrn-unguided.t7';
gpu_num=0

mkdir -p $output_folder
mkdir -p $input_folder/scaled

H=`pwd`
cd face-alignment

CUDA_VISIBLE_DEVICES=$gpu_num th main.lua -model 2D-FAN-300W.t7 -input ../$input_folder -detectFaces true -mode generate -output ../$input_folder -outputFormat txt

cd $H

CUDA_VISIBLE_DEVICES=$gpu_num th process.lua --model $model_file --input $input_folder/scaled/ --output $output_folder
