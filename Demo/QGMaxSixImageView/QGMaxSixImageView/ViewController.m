//
//  ViewController.m
//  QGMaxSixImageView
//
//  Created by 张如泉 on 2017/6/18.
//  Copyright © 2017年 QuanGe. All rights reserved.
//

#import "ViewController.h"
#import <QGMaxSixImageView.h>
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    QGMaxSixImageView *subview = [[QGMaxSixImageView alloc] init];
    NSArray * data = @[@{@"width":@(2896),@"height":@(4344),@"url":@"https://c.shijue.me/graphic/89ff72f764b0483517ed7e6016f3d9874/a0c6fdfd5fdd4a988788343b337d7865.jpg"},
                       @{@"width":@(4245),@"height":@(2830),@"url":@"https://c.shijue.me/graphic/89ff72f764b0483517ed7e6016f3d9874/fdb58819acc142e8a89f57473c4e8876.jpg"},
                       @{@"width":@(3736),@"height":@(5096),@"url":@"https://c.shijue.me/groupPhoto/89ff72f764b0483517ed7e6016f3d9874/824c2d96dd794d689175b2bd5e732bb9.jpg"},
                       @{@"width":@(3367),@"height":@(5051),@"url":@"https://c.shijue.me/groupPhoto/89ff72f764b0483517ed7e6016f3d9874/fca3fa2b5944429baab582cefb30ba3e.jpg"},
                       @{@"width":@(2761),@"height":@(4141),@"url":@"https://c.shijue.me/groupPhoto/89ff72f764b0483517ed7e6016f3d9874/86bd2cdab81d4b1eb5d5859469af6876.jpg"},
                       @{@"width":@(2189),@"height":@(3327),@"url":@"https://c.shijue.me/groupPhoto/89ff72f764b0483517ed7e6016f3d9874/3ff1099bb6a142b3ac055af5e36badf8.jpg"}
                       ];
    
    [self.view addSubview:subview];
    subview.backgroundColor = [UIColor blueColor];
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(70);
        make.height.mas_equalTo(300);
    }];
    subview.imageLoader = ^(UIImageView *imageView, id itemData) {
        NSString *urlStr =[NSString stringWithFormat:@"%@!p2",itemData[@"url"]];
        NSLog(@"%@",urlStr);
        [imageView setImageWithURL:[NSURL URLWithString:urlStr]];
    };
    [subview changeItemSpaceingLineColor:[UIColor whiteColor]];
    subview.imageNumHeight = 30;
    subview.imageNumLabel.text = [NSString stringWithFormat:@"共%@张照片",@(data.count)];
    
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat height = [subview updateImageData:data uiWidht:self.view.bounds.size.width];
        [subview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(70);
            make.height.mas_equalTo(height);
        }];
    CGFloat h = [QGMaxSixImageView updataImageData:data uiWidht:self.view.bounds.size.width imageItemSpacing:2 imageNumHeight:30];
    NSLog(@"%@",@(h));
    //});
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
