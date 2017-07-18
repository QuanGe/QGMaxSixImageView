//
//  QGMaxSixSizeCalculator.m
//  Pods
//
//  Created by git on 2017/7/17.
//
//

#import "QGMaxSixSizeCalculator.h"
@interface QGMaxSixSizeCalculator ()


@property (nonatomic, strong) NSMutableArray *leftOvers;
@property (nonatomic, assign) NSInteger lastIndexAdded;
@property (nonatomic, strong) NSArray *originSize;
@property (nonatomic, assign) NSInteger lineNum;

@end
@implementation QGMaxSixSizeCalculator
- (instancetype)initWithRowMaximumHeight:(CGFloat)rowMaximumHeight contentWidth:(CGFloat)contentWidth interItemSpacing:(CGFloat)interItemSpacing lineMaximumNum:(NSInteger)lineMaximumNum{
    self = [super init];
    if (self) {
        self.rowMaximumHeight = rowMaximumHeight;
        self.contentWidth = contentWidth;
        self.interItemSpacing = interItemSpacing;
        self.lineMaximumNum = lineMaximumNum;
    }
    return self;
}

- (void)calculatorCellItemSizeWithImageSizes:(NSArray*)imgesizes {
    self.originSize = imgesizes;
    [self calculatorCellItemSize];
}

- (void)calculatorCellItemSize {
    self.lastIndexAdded = 0;
    [self computeSizesAtIndex:0];
   
}


- (void)clearCache
{
    [self.sizeCache removeAllObjects];
}

//- (void)clearCacheAfterIndexPath:(NSIndexPath *)indexPath
//{
//    // Remove the indexPath
//    [self.sizeCache removeObjectForKey:indexPath];
//    
//    // Remove the indexPath for anything after
//    for (NSIndexPath *existingIndexPath in [self.sizeCache allKeys]) {
//        if ([indexPath compare:existingIndexPath] == NSOrderedDescending) {
//            [self.sizeCache removeObjectForKey:existingIndexPath];
//        }
//    }
//}

#pragma mark - Private methods

- (void)computeSizesAtIndex:(NSInteger)index
{
    if (!self.originSize)
        return;
    if(index >=self.originSize.count)
        return;
    if(!self.originSize[index][@"width"])
        return;
    if(!self.originSize[index][@"height"])
        return;
    
    CGSize photoSize = CGSizeMake([self.originSize[index][@"width"] floatValue], [self.originSize[index][@"height"] floatValue]);
    
    [self.leftOvers addObject:[NSValue valueWithCGSize:photoSize]];
    
    BOOL enoughContentForTheRow = NO;
    CGFloat rowHeight = self.rowMaximumHeight;
    
    CGFloat totalAspectRatio = 0.0;
    
    for (NSValue *leftOver in self.leftOvers) {
        CGSize leftOverSize = [leftOver CGSizeValue];
        totalAspectRatio += (leftOverSize.width / leftOverSize.height);
    }
    
    rowHeight = self.contentWidth / totalAspectRatio;
    enoughContentForTheRow = rowHeight < self.rowMaximumHeight;

    
    if (enoughContentForTheRow || (index == self.originSize.count-1)) {
        // The line is full!
        
        CGFloat availableSpace = self.contentWidth;
        NSInteger tempIndex = 0;
        for (NSValue *leftOver in self.leftOvers) {
            
            CGSize leftOverSize = [leftOver CGSizeValue];
            
            CGFloat newWidth = floor((rowHeight * leftOverSize.width) / leftOverSize.height);
            
            
            newWidth = MIN(availableSpace, newWidth);
            
            
            // Add the size in the cache
            [self.sizeCache addObject:[NSValue valueWithCGSize:CGSizeMake(newWidth, rowHeight)] ];
            
            availableSpace -= newWidth;
            availableSpace -= self.interItemSpacing;
            
            // We need to keep track of the last index path added
            self.lastIndexAdded = self.lastIndexAdded + 1;
            tempIndex++;
        }
        
        [self.leftOvers removeAllObjects];
        self.totalHeight += rowHeight+self.interItemSpacing;
        self.lineNum++;
        if(self.lineMaximumNum != 0 && self.lineNum == self.lineMaximumNum){
            return;
        }
        
    }
    
    [self computeSizesAtIndex: index+ 1];
    
}

#pragma mark - Custom accessors

- (NSMutableArray *)leftOvers
{
    if (!_leftOvers) {
        _leftOvers = [NSMutableArray array];
    }
    
    return _leftOvers;
}

- (NSMutableArray *)sizeCache
{
    if (!_sizeCache) {
        _sizeCache = [NSMutableArray array];
    }
    return _sizeCache;
}

@end
