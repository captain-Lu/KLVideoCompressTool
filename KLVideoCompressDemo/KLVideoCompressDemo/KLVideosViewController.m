//
//  KLVideosViewController.m
//  KLCameraPickerDemo
//
//  Created by 快摇002 on 16/7/21.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import "KLVideosViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KLVideo.h"
#import "KLVideoCell.h"
#import "SDAutoLayout.h"
#import "KLVideoCompressTool.h"

@interface KLVideosViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,KLVideoCompressToolDelegate>

@property (strong, nonatomic) UIImageView *topView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *videoArray;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) KLVideoCompressTool *compressTool;

@end

@implementation KLVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerCollectionViewCell];
    [self.view addSubview:self.collectionView];

    [self layoutSubView];

    [self getAssetsLibrary];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    NSLog(@"KLVideosViewController释放");
}

#pragma mark - pravite

- (void)layoutSubView
{
    [self.view addSubview:self.topView];
    self.topView.sd_layout
    .leftSpaceToView (self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(44);

    UILabel *label = [[UILabel alloc]init];
    label.text = @"本地视频";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label];
    label.sd_layout
    .centerYEqualToView(self.topView)
    .centerXEqualToView(self.topView)
    .heightIs(20);
    [label setSingleLineAutoResizeWithMaxWidth:150];

    UIButton *cancelButton = [[UIButton alloc]init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelButton];
    cancelButton.sd_layout
    .leftSpaceToView(self.topView,10)
    .centerYEqualToView(self.topView)
    .widthIs(30)
    .heightEqualToWidth();
}

- (void)registerCollectionViewCell
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"KLVideoCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCell"];
    self.collectionView.alwaysBounceVertical = YES;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    self.collectionView.collectionViewLayout = layout;
}

- (void)getAssetsLibrary
{
    //取出所有的文件夹
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            //遍历文件夹中的资源文件
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    KLVideo *video = [[KLVideo alloc]init];
                    video.url = [result valueForProperty:ALAssetPropertyAssetURL];
                    video.time = [[result valueForProperty:ALAssetPropertyDuration]integerValue];

                    if (![[self.videoArray valueForKey:@"url"] containsObject:video.url]) {
                        [self.videoArray addObject:video];
                    }
                }
            }];
        }
        else
        {
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
    }];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - 15)/4, (self.view.frame.size.width - 15)/4);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.video = [self.videoArray objectAtIndex:indexPath.row];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(44+5, 0, 5, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLVideo *video = [self.videoArray objectAtIndex:indexPath.row];
    KLVideoCompressTool *compress = [KLVideoCompressTool defaultCompresserWith:video.url];
    compress.delegate = self;
    [compress startCompress];
    self.compressTool = compress;
}

#pragma mark - KLVideoCompressToolDelegate

- (void)videoCompressFail:(NSString *)state
{
    NSLog(@"%@",state);
}

- (void)videoCompressSuccess:(NSString *)videoPath videoFileSize:(unsigned long long)size
{
    NSLog(@"%@-----%lld",videoPath,size);
}

#pragma mark - lazyload

- (ALAssetsLibrary *)assetsLibrary
{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc]init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)videoArray
{
    if (_videoArray == nil) {
        _videoArray = [[NSMutableArray alloc]init];
    }
    return _videoArray;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (UIImageView *)topView
{
    if (_topView == nil) {
        _topView = [[UIImageView alloc]init];
        _topView.image = [UIImage imageNamed:@"camera-bottom-bg"];
        _topView.userInteractionEnabled = YES;
    }
    return _topView;
}

@end
