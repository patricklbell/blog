---
date: "2023-09-02"
title: "Image Segmentation of Microscope Slides"
author: "Patrick Bell"
slug: "kidney-vasculature-nn"
comments: true
tags: [ "Machine Learning", "Mathematics" ]
caption: "Using machine learning to identify veins from microscope slides of kidney cells."
img:
  name: "/posts/kidney-vasculature-nn/header.png"
  alt: "An example of a microscope slide from the kidneys"
---
The HuBMAP challenge on Kaggle{{< cite "-hubmap-hacking-the-human-vasculature" >}} aimed to segment regions of microvascular (blood vessels) from other tissue in a microscope slide of a healthy human kidney. Each pixel from a stained slide of the kidneys should be labeled as part of a vein or not. This page explores how to apply a convolutional neural network to the HuBMAP challenge. Otsu's segmentation is used as an example of a simpler, but ineffective approach, which justifies the machine learning approach.

{{<figure src="imgs/header.png" caption="*Image from PAS stained slide of the kidneys*" >}}

## Slide and Label Data
Whole Slide Images (WSIs) from Periodic acid-Schiff stained tissues slides were obtained from five healthy adults. These slides were split into {{< latex >}}$7034${{< /latex >}} tiles each of which is {{< latex >}}$512 \times 512${{< /latex >}} pixels, 8 bit RGB TIFF files. A CSV file contains the source WSI and location of each tile within the WSI. Of the {{< latex >}}$7034${{< /latex >}} tiles, {{< latex >}}$1633${{< /latex >}} were labeled by expert pathologists. Three different structures were labelled, `blood_vessel`, `glomerulus`, and `unsure`. The labels are given per tile as a list polygons for each label. The model should predict a `blood_vessel` label for an unlabelled tile.

## Background
Semantic segmentation is the 

> task of clustering parts of images together which belong to the same object class.  {{< cite "thoma-16" >}}

There exist several classical segmentation techniques, including thresh-holding, Otsu's method, active contour and mean shift. In recent years, deep convolutional neural networks (CNNs) have performed well in image segmentation{{< cite "-unet" >}} including segmentation of microscope slides{{< cite "-Persson1680464" >}}.


There exist many CNNs designed for image segmentation, such as U-Net {{< cite "-unet" >}}, DeepLab {{< cite "-chen2017deeplab" >}}, and ErfNet {{< cite "-erfnet" >}}. In some cases, an already trained network may be used and adapted by retraining through transfer learning. Transfer learning has been used successfully in biological image analysis {{< cite "-zhang2020transferbio" >}}.

## Implementation
All source code can be found [here](https://github.com/patricklbell/HuBMAP), metrics were recorded with [WandB](https://wandb.ai).

### Processing
In order to apply and evaluate our algorithms we need to convert the label data from polygons into mask files to match the training images. The polygons of each `blood_vessel` label are converted to a mask image. Any tiles which had no labels, including `glomerulus` and `unsure`, are ignored in training. If a tile has a label, but not a `blood_vessel` label, a blank mask is generated.

{{<figure src="imgs/processing.png" caption="*Fig 1. Mask generated for a training example.*" >}}

### Metrics
We need useful metrics which can be used to evaluate our algorithm's success. Müller {{< cite "-müller2022guideline" >}} suggested a guideline for evaluation metrics for medical image segmentation tasks. These metrics are formally defined below, feel free to skip this section if you are already familiar with DSC, IoU, and Sensitivity and Specificity.


Let {{< latex >}}$X,Y \in \set{0,1}^{w \times h}${{< /latex >}} be matrices representing the predicted and ground-truth labels respectively. A {{< latex >}}$1${{< /latex >}} in the matrix means the corresponding pixel is part of a vein. The true-positives, false-positives, false-negatives and true-negative counts are given by
```latex
\newcommand{\norm}[1]{\left\lVert#1\right\rVert}
\begin{equation*}
    \begin{aligned}
        TP &= \norm{X \circ Y}_1 \\\
        FN &= \norm{(1-X) \circ Y}_1
    \end{aligned}
    \qquad
    \begin{aligned}
        FP &= \norm{X \circ (1-Y)}_1 \\\
        TN &= \norm{(1-X) \circ (1-Y)}_1
    \end{aligned}
\end{equation*}
```
where {{< latex >}}$\circ${{< /latex >}} is the element-wise product.

Müller {{< cite "-müller2022guideline" >}} suggests the dice similarity coefficient (DSC) and intersection over union (IoU or Jaccard index) because they are unbiased metrics (pixel accuracy is an example of a biased metric). Biased metrics can cause models which classify unbalanced classes to look more accurate than if balanced classes were classified.
```latex
\begin{align*}
    \text{DSC} &= \frac{2 TP}{2 TP + FP + FN} \\\
    \text{IoU} &= \frac{TP}{TP + FP + FN}
\end{align*}
```

Additionally, sensitivity and specificity are used to demonstrate functionality but not performance.

```latex
\begin{align*}
    \text{Sensitivity} &= \frac{TP}{TP + FN} \\\
    \text{Specificity} &= \frac{TN}{TN + FP}
\end{align*}
```

## Experiments
### Otsu's Thresholding
Before jumping to more complex deep learning techniques, a simpler model should be considered. Otsu's segmentation is one of the simplest forms of image segmentation. The algorithm finds the optimal binary threshold to separate an image into two classes which have least variance. The algorithm minimizes
```latex
\begin{align*}
    \sigma^2_w(t) = w_0(t)\sigma^2_0(t) + w_1(t)\sigma^2_1(t)\\
\end{align*}
```
where {{< latex >}}$w_0${{< /latex >}} and {{< latex >}}$w_1${{< /latex >}} is the probability of a pixel belonging to the classes {{< latex >}}$0${{< /latex >}} and {{< latex >}}$1${{< /latex >}}, which are seperated by the threshold {{< latex >}}$t${{< /latex >}}, and {{< latex >}}$\sigma_0^2${{< /latex >}} and {{< latex >}}$\sigma_1^2${{< /latex >}} are the variances of these respective classes {{< cite "-otsu" >}}.

Otsu's segmentation is a reasonable baseline for testing if machine learning is necessary to solve this problem. We can see by looking at the training data that a thresholding algorithm won't work in all cases as some contextual information is required and table 1 shows Otsu's is not much better than random noise. We need to use machine learning and table 1 will be a useful baseline for our neural network.

{{<figure src="imgs/report-01.png" darksrc="imgs/report-dark-01.png" caption="*Table 1. Comparison of different algorithms. The metrics are calculated by averaging across the entire training set. The full and no segmentation scores demonstrate the class proportions.*"  >}}

### U-Net

{{<figure src="imgs/unet-architecture.png" caption="*Fig 2. The U-Net architecture, a down-sampling encoder extracts information into many feature channels which are then up-sampled to return to the original resolution. Arrows represent operations, blue boxes are multi-channel feature maps and white boxes are copied feature maps.*" >}}

U-Net is a fully convolutional neural network which was introduced by Ronneberger et al. {{< cite "-unet" >}} where it was successful in segmenting neurons from electron microscope data. U-Net is widely used in medical image segmentation. U-Net's architecture is shown in figure 2, it contains no fully connected layers so can accept any resolution image as input. 

The model and training harness are modified from [Pytorch-UNet](https://github.com/milesial/Pytorch-UNet). For the following experiments a standard 90-10 random train-test split is used. U-Net's logits are passed through a sigmoid to be convert to a probability.

{{<figure src="imgs/report-02.png" darksrc="imgs/report-dark-02.png" class="floatright" caption="*Table 2. Settings and hyper-parameters initially used to train the U-Net the optimizer and batch size match the original U-Net paper.*"  >}}

#### Normalization and Image Transformation
The model is initially trained without normalizing the tiles. Figure 3 compares DSC during training for normalized and raw tiles. The tiles are normalized with [Albumentations](https://albumentations.ai/) with a mean and standard deviation pre-calculated from the entire training set.[^1] 

Applying normalization allowed the epoch loss to decrease more quickly, this could be due to overfitting, but the validation shows an {{< latex >}}$\approx 50 \\%${{< /latex >}} greater peak DSC over no normalization. Applying random morphological and color transforms didn't seem to have any benefit and slowed training.

{{<figure src="imgs/DSC-transforms.png" >}}
{{<figure src="imgs/epoch-loss-transforms.png" caption="*Fig 3. Result from training with different image pre-processing techniques. Epoch loss is the average loss for each training epoch, all other metrics are recalculated on the validation split at the end of an epoch. `transform` applies random morphological and color transforms using `Albumentations`, `morphtransform` only applies the morphological transforms.*" >}}

[^1]: This technically causes data leaking from the training set to validation set.

#### Batch Size
The U-Net paper {{< cite "-unet" >}} suggests a batch size of {{< latex >}}$1${{< /latex >}} to maximise GPU usage and a correspondingly high momentum. Kandel et al. {{< cite "-batchsize" >}} investigated different batch sizes when applied to CNN image classifiers and states that low batch sizes can lead the network to "bounce back and forth without achieving acceptable performance." The DSC in figure 3 shows this characteristic ping-ponging suggesting the batch size is too low. On the other hand, higher batch sizes can mean training takes too long to converge, the optimum batch size depends on many factors including the data-set {{< cite "-batchsize" >}}, so experimentation is required. 

{{<figure src="imgs/batch-dsc.png" >}}
{{<figure src="imgs/batch-iou.png" caption="*Fig 4. Validation metrics for different batch sizes. The horizontal scale is relative time since training started, since we are concerned with performance over equivalent training time.*" >}}

Figure 4 shows that as batch size increases, IoU and DSC takes longer to improve but show less variance, as predicted by Kandel et al. Higher batch sizes seem to reach a greater peak DSC, but IoU shows a greater peak for low batch sizes, this may be because more epochs are required {{< cite "-batchsize" >}} to converge. A batch size of {{< latex >}}$16${{< /latex >}} was chosen as optimal.

#### Loss Function
The loss function measures how far a predicted label is from the ground truth. Binary Cross Entropy (`BCEwithLogitLoss`) is a widely used loss function in semantic segmentation {{< cite "-Jadon_2020" >}} because of its stability. There exist other common semantic segmentation loss functions, which include focal loss, and combo loss {{< cite "-Jadon_2020" >}}. With the help of [*bigironsphere*'s Kaggle notebook](https://www.kaggle.com/code/bigironsphere/loss-function-library-keras-pytorch#BCE-Dice-Loss) the loss functions which are not built-in can be implemented in `PyTorch`. See Jadon et al. {{< cite "-Jadon_2020" >}} for the mathematical definition of these loss functions, my focal implementation sets {{< latex >}}$\alpha_t = 0.95 = 1 - 0.05${{< /latex >}} to the inverse class frequency and {{< latex >}}$\gamma = 2${{< /latex >}}, my combo loss weighs BCE and dice equally where {{< latex >}}$\alpha=0.5${{< /latex >}}. Before applying focal and combo loss, U-Net's logit output is passed through a sigmoid.

{{<figure src="imgs/loss-dsc.png" >}}
{{<figure src="imgs/loss-iou.png" caption="*Fig 5. Validation metrics for different loss functions. All runs are performed with batch sizes of {{< latex >}}$16${{< /latex >}} over {{< latex >}}$40${{< /latex >}} epochs, training over more epochs could show more useful results.*" >}}

Figure 5 compares these metrics over equivalent training setups. Combo consistently out performed BCE and focal loss, showing less variability and an {{< latex >}}$\approx 10\\%${{< /latex >}} greater peak metric. Focal loss performed very poorly, this may due improper tuning of the {{< latex >}}$\alpha${{< /latex >}} and {{< latex >}}$\gamma${{< /latex >}} hyper-parameters, as when {{< latex >}}$\gamma = 1${{< /latex >}}, focal loss should be equivalent to BCE {{< cite "-Jadon_2020" >}}.

## Results
After tuning these hyper-parameters a final model was trained over {{< latex >}}$160${{< /latex >}} epochs with a batch size of {{< latex >}}$16${{< /latex >}} using a combo loss function. The DSC shown in figure 6 shows the model converged towards a DSC of {{< latex >}}$\approx 0.6${{< /latex >}}. Results and an example of the model's predictions are shown in table 3.

{{<figure src="imgs/best-dsc.png" >}}
{{<figure src="imgs/best-iou.png" >}}
{{<figure src="imgs/best-loss.png" >}}
{{<figure src="imgs/best-sensitivity.png" caption="*Fig 6. Validation metrics calculated while training the final model. Loss is shown per batch, rather than per epoch.*" >}}

{{<figure src="imgs/report-03.png" darksrc="imgs/report-dark-03.png" caption="*Table 3. Metrics over validation set from the models at 40<sup>th</sup>, 80<sup>th</sup> and 160<sup>th</sup> epoch with an example. Refer to table 1 for examples of these metrics on simpler segmentations.*"  >}}


## Conclusion
This page examined different techniques and parameters when applying semantic segmentation techniques to the *HuBMAP - Hacking the Human Vasculature* competition. We found that normalization of input images allowed the loss to decrease more quickly. Applying random morphological or color transformation did not seem effective on this data-set. For the standard U-Net architecture, Combo loss outperformed the simpler binary cross entropy loss and focal loss. Greater batch sizes decreased loss variance at the cost of training time and should be tuned for each data-set.

## References
{{< bibliography cited >}}