#!/bin/bash

cp 1/* ~/Codes/libsvm-3.18/tools/
cd /Users/zhangchi8620/Codes/libsvm-3.18/tools/
python easy.py train.txt test.txt | grep Accuracy

cd /Users/zhangchi8620/Data/Human-Skeleton/dataset_mfile/result/eachTrain_eachTest/20GMM_1DR 
cp 2/* ~/Codes/libsvm-3.18/tools/
cd /Users/zhangchi8620/Codes/libsvm-3.18/tools/
python easy.py train.txt test.txt | grep Accuracy


cd /Users/zhangchi8620/Data/Human-Skeleton/dataset_mfile/result/eachTrain_eachTest/20GMM_1DR 
cp 3/* ~/Codes/libsvm-3.18/tools/
cd /Users/zhangchi8620/Codes/libsvm-3.18/tools/
python easy.py train.txt test.txt | grep Accuracy

cd /Users/zhangchi8620/Data/Human-Skeleton/dataset_mfile/result/eachTrain_eachTest/20GMM_1DR 
cp 4/* ~/Codes/libsvm-3.18/tools/
cd /Users/zhangchi8620/Codes/libsvm-3.18/tools/
python easy.py train.txt test.txt | grep Accuracy

cd /Users/zhangchi8620/Data/Human-Skeleton/dataset_mfile/result/eachTrain_eachTest/20GMM_1DR 
cp 5/* ~/Codes/libsvm-3.18/tools/
cd /Users/zhangchi8620/Codes/libsvm-3.18/tools/
python easy.py train.txt test.txt | grep Accuracy
