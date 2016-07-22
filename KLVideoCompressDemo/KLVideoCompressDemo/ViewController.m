//
//  ViewController.m
//  KLVideoCompressDemo
//
//  Created by 快摇002 on 16/7/21.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import "ViewController.h"
#import "KLVideosViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)localVideos:(id)sender {

    KLVideosViewController *videos = [[KLVideosViewController alloc]init];
    [self presentViewController:videos animated:YES completion:nil];
}


@end
