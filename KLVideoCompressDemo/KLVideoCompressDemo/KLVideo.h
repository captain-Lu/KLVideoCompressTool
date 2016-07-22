//
//  KLVideo.h
//  KLCameraPickerDemo
//
//  Created by 快摇002 on 16/7/21.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KLVideo : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *url;
@property (assign, nonatomic) NSInteger time;

@end
