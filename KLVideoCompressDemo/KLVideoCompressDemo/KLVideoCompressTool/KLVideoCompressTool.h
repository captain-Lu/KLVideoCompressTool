//
//  KLVideoCompressTool.h
//  KLVideoCompressDemo
//
//  Created by 快摇002 on 16/7/21.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLVideoCompressTool;

/**
 *  协议
 */
@protocol KLVideoCompressToolDelegate <NSObject>

/**
 *  压缩成功回调，默认输出mp4格式，MediumQuality质量
 *
 *  @param url  压缩完成后的视频文件路径
 *  @param size 压缩完成后视频文件的大小
 */
- (void)videoCompressSuccess:(NSString *)videoPath videoFileSize:(unsigned long long)size;
/**
 *  压缩失败回调
 *
 *  @param state 失败的状态
 */
- (void)videoCompressFail:(NSString *)state;

@end

@interface KLVideoCompressTool : NSObject

@property (weak, nonatomic) id<KLVideoCompressToolDelegate> delegate;

/**
 *  类方法
 *
 *  @param url 本地视频文件url
 *
 *  @return 对象
 */
+(instancetype)defaultCompresserWith:(NSURL *)url;
/**
 *  开始压缩
 */
- (void)startCompress;
/**
 *  如果不希望保留压缩后的文件使用该方法清除
 *
 *  @param filePath 压缩文件路径
 */
- (BOOL)clearVideoCompressCacheFile:(NSString *)filePath;

@end
