//
//  QGMaxSixImageView.h
//  QGMaxSixImageView
//
//  Created by 张如泉 on 2017/6/18.
//  Copyright © 2017年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QGMaxSixImageView : UIView
@property (nonatomic, copy) void (^imageLoader)(UIImageView *imageView,id itemData);
@property (assign,nonatomic) NSInteger imageItemSpacing;
@property (strong,nonatomic) UILabel *imageNumLabel;
@property (assign,nonatomic) NSInteger imageNumHeight;

- (void)updateImageData:(NSArray*)data imageSizes:(NSArray *)imageSizes;
- (void)changeItemSpaceingLineColor:(UIColor*)color;
@end
