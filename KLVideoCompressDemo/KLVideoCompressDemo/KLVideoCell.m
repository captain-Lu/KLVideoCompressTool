//
//  KLVideoCell.m
//  KLCameraPickerDemo
//
//  Created by 快摇002 on 16/6/17.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import "KLVideoCell.h"
#import <AVFoundation/AVFoundation.h>

@interface KLVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *phootoImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation KLVideoCell


- (void)setResult:(ALAsset *)result
{
    _result = result;

    NSNumber *time = [result valueForProperty:ALAssetPropertyDuration];
    NSURL *url = [result valueForProperty:ALAssetPropertyAssetURL];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.phootoImageView.image = [self imageWithMediaURL:url];
    });
    self.timeLable.text = [self timeStringWith:time.integerValue];
}

- (void)setVideo:(KLVideo *)video
{
    _video = video;

    if (video.image == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.phootoImageView.image = [self imageWithMediaURL:video.url];
            self.video.image = self.phootoImageView.image;
        });
    }
    else
    {
        self.phootoImageView.image = video.image;
    }

    self.timeLable.text = [self timeStringWith:video.time];
}

- (UIImage *)imageWithMediaURL:(NSURL *)url
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(600, 450);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10000) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    return image;
}

- (NSString *)timeStringWith:(NSInteger )seconds
{
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

}

@end
