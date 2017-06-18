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

//you image data must be format [{"width":2896,"height":4344,"orther":@"..."},{"width":2896,"height":4344,"orther":@"..."}]
//and return the view height
- (CGFloat)updateImageData:(NSArray*)data uiWidht:(CGFloat)width;
+ (CGFloat)updataImageData:(NSArray*)data uiWidht:(CGFloat)width imageItemSpacing:(CGFloat)imageItemSpacing;
- (void)changeItemSpaceingLineColor:(UIColor*)color;
@end
