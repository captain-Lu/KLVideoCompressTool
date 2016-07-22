//
//  KLVideoCell.h
//  KLCameraPickerDemo
//
//  Created by 快摇002 on 16/6/17.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "KLVideo.h"

@interface KLVideoCell : UICollectionViewCell

@property (strong, nonatomic) ALAsset *result;

@property (strong, nonatomic) KLVideo *video;

@end
