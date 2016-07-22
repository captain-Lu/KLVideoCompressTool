# KLVideoCompressTool
基于AVFoundataion框架实现的一款用于压缩本地视频文件的工具

####前言
读取iphone相册本地中的视频文件路劲：assets-library://asset/asset.mov?id=xxxxxxxx-xxxxx-xxxx-xxxx-xxxxxxxxxxx&ext=mov形式
可以使用这种路径进行视频播放等操作，但不能用于视频上传，意思就是不能用于数据传输的载体，因此如果需要上传到服务器，需要读取-压缩-写入沙盒三部。

####本工具使用
- 类方法创建单例对象
```objc
/**
 *  类方法
 *
 *  @param url 本地视频文件url
 *
 *  @return 对象
 */
+(instancetype)defaultCompresserWith:(NSURL *)url;
/**
```

- 开始压缩
```objc
/**
 *  开始压缩
 */
- (void)startCompress;

```

- 代理回调
```objc
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
```

最后，本工具用于学习和探讨，大神忽喷，后续会持续更新优化。
