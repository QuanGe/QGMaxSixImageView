//
//  QGMaxSixSizeCalculator.h
//  Pods
//
//  Created by git on 2017/7/17.
//
//

#import <Foundation/Foundation.h>

@interface QGMaxSixSizeCalculator : NSObject
@property (nonatomic,strong,readwrite) NSMutableArray *sizeCache;
@property (nonatomic,assign,readwrite)  CGFloat rowMaximumHeight;
@property (nonatomic,assign,readwrite)  NSInteger lineMaximumNum;
@property (nonatomic,assign,readwrite)  CGFloat contentWidth;
@property (nonatomic,assign,readwrite)  CGFloat interItemSpacing;
@property (nonatomic,assign,readwrite)  CGFloat totalHeight;

- (instancetype)initWithRowMaximumHeight:(CGFloat)rowMaximumHeight contentWidth:(CGFloat)contentWidth interItemSpacing:(CGFloat)interItemSpacing lineMaximumNum:(NSInteger)lineMaximumNum;

- (void)calculatorCellItemSizeWithImageSizes:(NSArray*)imgesizes;
- (void)calculatorCellItemSize;
@end
