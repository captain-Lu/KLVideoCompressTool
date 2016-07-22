//
//  KLVideoCompressTool.m
//  KLVideoCompressDemo
//
//  Created by 快摇002 on 16/7/21.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import "KLVideoCompressTool.h"
#import "NSString+Extension.h"
#import <AVFoundation/AVFoundation.h>

@interface KLVideoCompressTool ()

@property (strong, nonatomic) NSURL *url;
@property (copy, nonatomic) NSString *saveVideoPath;
@property (assign, nonatomic) BOOL onCompress;

@end

@implementation KLVideoCompressTool

+(instancetype)defaultCompresserWith:(NSURL *)url
{
    static KLVideoCompressTool *defaultCompresser = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultCompresser = [[super alloc] init];

        defaultCompresser.url = url;
        NSString * saveVideopath = [NSString stringWithFormat:@"%@/Library/NBCache/%@/SaveVideo/",NSHomeDirectory(),@"123456789"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:saveVideopath])
        {
            NSError * error = nil;
            if ([[NSFileManager defaultManager] createDirectoryAtPath:saveVideopath withIntermediateDirectories:YES attributes:nil error:&error]){
            }
            else
            {
                NSLog(@"%@",error);
            }
        }
        defaultCompresser.saveVideoPath = saveVideopath;
    });
    return defaultCompresser;
}

- (void)startCompress
{
    if (self.onCompress)
    {
        NSLog(@"正在压缩进程中...");
        return;
    }
    [self videoCompressionWith:self.url toVideoSavePath:self.saveVideoPath localVideoPath:nil videoThumbnailPath:nil];
}

-(void)videoCompressionWith:(NSURL *)url toVideoSavePath:(NSString *)videoSavePath localVideoPath:(NSString *)localPath videoThumbnailPath:(NSString *)videoThumb
{
    NSString * videoOutputPath = [NSString stringWithFormat:@"%@%@.mp4",videoSavePath,[[NSString stringWithFormat:@"%@",url] md5]];
    __weak typeof(self)weakSelf = self;
    if (![[NSFileManager defaultManager] fileExistsAtPath:videoOutputPath])
    {
        AVURLAsset * urlAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:urlAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.outputURL = [NSURL fileURLWithPath:videoOutputPath];
        NSLog(@"开始压缩");
        self.onCompress = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch (exportSession.status)
            {
                case AVAssetExportSessionStatusUnknown:{
                    if (weakSelf.delegate) {
                        [weakSelf.delegate videoCompressFail:@"AVAssetExportSessionStatusUnknown"];
                    }
                    break;
                }
                case AVAssetExportSessionStatusWaiting:{
                    if (weakSelf.delegate) {
                        [weakSelf.delegate videoCompressFail:@"AVAssetExportSessionStatusWaiting"];
                    }
                    break;
                }
                case AVAssetExportSessionStatusExporting:{
                    if (weakSelf.delegate) {
                        [weakSelf.delegate videoCompressFail:@"AVAssetExportSessionStatusExporting"];
                    }
                    break;
                }
                case AVAssetExportSessionStatusCompleted:{
                    [weakSelf videoCompressSuccess:url savePath:videoOutputPath videoThumbPath:videoThumb];
                    break;
                }
                case AVAssetExportSessionStatusFailed:{
                    if (weakSelf.delegate) {
                        [weakSelf.delegate videoCompressFail:@"AVAssetExportSessionStatusFailed"];
                    }
                    break;
                }
                case AVAssetExportSessionStatusCancelled:{
                    if (weakSelf.delegate) {
                        [weakSelf.delegate videoCompressFail:@"AVAssetExportSessionStatusCancelled"];
                    }
                    break;
                }
                default:
                    break;
            }
            self.onCompress = NO;
        }];
    } else {
        [weakSelf videoHasExist:url filePath:videoOutputPath];
    }
}

-(void)videoCompressSuccess:(NSURL *)url savePath:(NSString *)savePath videoThumbPath:(NSString *)thumbPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    unsigned long long size = [[manager attributesOfItemAtPath:savePath error:nil] fileSize];
    if (self.delegate) {
        [self.delegate videoCompressSuccess:savePath videoFileSize:size];
    }
    NSLog(@"压缩成功");
}

-(void)videoHasExist:(NSURL *)url filePath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    unsigned long long size = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    if (self.delegate) {
        [self.delegate videoCompressSuccess:filePath videoFileSize:size];
    }
    NSLog(@"压缩成功");
}

- (BOOL)clearVideoCompressCacheFile:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL b = [manager removeItemAtPath:filePath error:&error];
    if (error)NSLog(@"%@",error);
    return b;
}

@end
