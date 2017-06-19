//
//  QGMaxSixImageView.m
//  QGMaxSixImageView
//
//  Created by 张如泉 on 2017/6/18.
//  Copyright © 2017年 QuanGe. All rights reserved.
//

#import "QGMaxSixImageView.h"

@interface QGMaxSixImageView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong,nonatomic) UICollectionView * collectionView;
@property (strong,nonatomic) NSArray *sourceImageData;
@property (strong,nonatomic) NSMutableArray *realImageData;

@property (strong,nonatomic) NSLayoutConstraint *imageNumHeightConstraint;
@property (strong,nonatomic) NSLayoutConstraint *collectionViewBottomConstraint;
@end
@implementation QGMaxSixImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initConfig];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self initConfig];
    return self;
}

- (void)initConfig{
    [self addSubview:self.collectionView];
    [self addSubview:self.imageNumLabel];
    self.imageItemSpacing = 2.0;
    self.realImageData = [NSMutableArray array];
    self.clipsToBounds = YES;
    self.imageNumHeight = 30;
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSMutableArray* collectionViewConstraints = [NSMutableArray arrayWithCapacity:0];
    
    [collectionViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [collectionViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [collectionViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    self.collectionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.imageNumHeight];
    [collectionViewConstraints addObject:self.collectionViewBottomConstraint];
    [self  addConstraints:collectionViewConstraints];
    
    NSMutableArray* imageNumViewConstraints = [NSMutableArray arrayWithCapacity:0];
    
    [imageNumViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.imageNumLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [imageNumViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.imageNumLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    self.imageNumHeightConstraint = [NSLayoutConstraint constraintWithItem:self.imageNumLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:self.imageNumHeight];
    [imageNumViewConstraints addObject:self.imageNumHeightConstraint];
    [imageNumViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.imageNumLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self  addConstraints:imageNumViewConstraints];
}

- (void)setImageNumHeight:(NSInteger)imageNumHeight {
    _imageNumHeight = imageNumHeight;
    self.imageNumHeightConstraint.constant = imageNumHeight;
    self.collectionViewBottomConstraint.constant = - imageNumHeight;
    [self layoutIfNeeded];
    
}



- (void)changeItemSpaceingLineColor:(UIColor*)color {
    self.collectionView.backgroundColor = color;
}

+ (CGFloat)updataImageData:(NSArray*)data uiWidht:(CGFloat)width  imageItemSpacing:(CGFloat)imageItemSpacing  imageNumHeight:(NSInteger)imageNumHeight{
    NSAssert(data, @"data must not be nil.");
    NSAssert(data.count>0, @"data count must > 0.");
    CGFloat uiHeight = 0;
    if(data.count == 1)
    {
        uiHeight = [QGMaxSixImageView calculateOneImageItemWithOne:data[0] uiWidht:width imageItemSpacing:imageItemSpacing];
        
    }
    else if (data.count == 2) {
        
        uiHeight =  [QGMaxSixImageView calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width imageItemSpacing:imageItemSpacing];
    }
    else if (data.count == 3) {
        CGFloat firstRatio = [data[0][@"height"] floatValue]/[data[0][@"width"] floatValue];
        CGFloat secondRatio = [data[1][@"height"] floatValue]/[data[1][@"width"] floatValue];
        CGFloat thirdRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
        if (firstRatio>1.0 && secondRatio>1.0 && thirdRatio>1.0) {
            uiHeight = [QGMaxSixImageView calculateThreeImageItemWithOne:data[0] another:data[1] thirdOne:data[2] uiWidht:width imageItemSpacing:imageItemSpacing];
        }
        else
        {
            CGFloat onelineHeight = [self calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width imageItemSpacing:imageItemSpacing];
            uiHeight = [QGMaxSixImageView calculateOneImageItemWithOne:data[2] uiWidht:width imageItemSpacing:imageItemSpacing] + onelineHeight+imageItemSpacing;
        }
    }
    else if(data.count == 4){
        CGFloat onelineHeight = [QGMaxSixImageView calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width imageItemSpacing:imageItemSpacing];
        uiHeight = [QGMaxSixImageView calculateTwoImageItemWithOne:data[2] another:data[3] uiWidht:width imageItemSpacing:imageItemSpacing] + onelineHeight+imageItemSpacing;
    }
    else if (data.count == 5){
        CGFloat firstRatio = [data[0][@"height"] floatValue]/[data[0][@"width"] floatValue];
        CGFloat secondRatio = [data[1][@"height"] floatValue]/[data[1][@"width"] floatValue];
        CGFloat thirdRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
        CGFloat onelineHeight = 0.0;
        if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0) || (firstRatio >1.0&& thirdRatio>1.0)) {
            onelineHeight = [QGMaxSixImageView calculateThreeImageItemWithOne:data[0] another:data[1] thirdOne:data[2] uiWidht:width imageItemSpacing:imageItemSpacing];
            uiHeight = onelineHeight + [QGMaxSixImageView calculateTwoImageItemWithOne:data[3] another:data[4] uiWidht:width imageItemSpacing:imageItemSpacing]+imageItemSpacing;
            
        }
        else {
            onelineHeight = [QGMaxSixImageView calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width imageItemSpacing:imageItemSpacing];
            firstRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
            secondRatio = [data[3][@"height"] floatValue]/[data[4][@"width"] floatValue];
            thirdRatio = [data[4][@"height"] floatValue]/[data[4][@"width"] floatValue];
            if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0)  || (firstRatio >1.0&& thirdRatio>1.0)) {
                
                uiHeight = onelineHeight + [QGMaxSixImageView calculateThreeImageItemWithOne:data[2] another:data[3] thirdOne:data[4] uiWidht:width imageItemSpacing:imageItemSpacing] +imageItemSpacing;
                
            }
            else {
                uiHeight = onelineHeight + [QGMaxSixImageView calculateTwoImageItemWithOne:data[2] another:data[3] uiWidht:width imageItemSpacing:imageItemSpacing] + imageItemSpacing;
            }
            
            
        }
        
    }
    else if (data.count >= 6){
        CGFloat firstRatio = [data[0][@"height"] floatValue]/[data[0][@"width"] floatValue];
        CGFloat secondRatio = [data[1][@"height"] floatValue]/[data[1][@"width"] floatValue];
        CGFloat thirdRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
        CGFloat onelineHeight = 0.0;
        if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0)  || (firstRatio >1.0&& thirdRatio>1.0)) {
            onelineHeight = [QGMaxSixImageView calculateThreeImageItemWithOne:data[0] another:data[1] thirdOne:data[2] uiWidht:width imageItemSpacing:imageItemSpacing];
            firstRatio = [data[3][@"height"] floatValue]/[data[3][@"width"] floatValue];
            secondRatio = [data[4][@"height"] floatValue]/[data[4][@"width"] floatValue];
            thirdRatio = [data[5][@"height"] floatValue]/[data[5][@"width"] floatValue];
            if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0)  || (firstRatio >1.0&& thirdRatio>1.0)) {
                uiHeight = onelineHeight + [QGMaxSixImageView calculateThreeImageItemWithOne:data[3] another:data[4] thirdOne:data[5] uiWidht:width imageItemSpacing:imageItemSpacing] +imageItemSpacing;
            } else {
                uiHeight = onelineHeight + [QGMaxSixImageView calculateTwoImageItemWithOne:data[4] another:data[5] uiWidht:width imageItemSpacing:imageItemSpacing] +imageItemSpacing;
            }
            
        }
        else {
            onelineHeight = [QGMaxSixImageView calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width imageItemSpacing:imageItemSpacing];
            firstRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
            secondRatio = [data[3][@"height"] floatValue]/[data[4][@"width"] floatValue];
            thirdRatio = [data[4][@"height"] floatValue]/[data[4][@"width"] floatValue];
            if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0)  || (firstRatio >1.0&& thirdRatio>1.0)) {
                
                uiHeight = onelineHeight + [QGMaxSixImageView calculateThreeImageItemWithOne:data[2] another:data[3] thirdOne:data[4] uiWidht:width imageItemSpacing:imageItemSpacing] +imageItemSpacing;
                
            }
            else {
                uiHeight = onelineHeight + [QGMaxSixImageView calculateTwoImageItemWithOne:data[2] another:data[3] uiWidht:width imageItemSpacing:imageItemSpacing] +imageItemSpacing;
            }
            
            
        }
        
    }
    
    return uiHeight + imageNumHeight;
}

+ (CGFloat)calculateOneImageItemWithOne:(NSDictionary*)one   uiWidht:(CGFloat)width  imageItemSpacing:(CGFloat)imageItemSpacing{
    
    CGFloat itemWidth = [one[@"width"] floatValue];
    CGFloat itemHeight = [one[@"height"] floatValue];
    CGSize realSize = CGSizeMake(width, width * (itemHeight/itemWidth));
    return realSize.height;
    
}
+ (CGFloat)calculateTwoImageItemWithOne:(NSDictionary*)one another:(NSDictionary*)another  uiWidht:(CGFloat)width imageItemSpacing:(CGFloat)imageItemSpacing{
    CGFloat twoImageRatio = [one[@"height"] floatValue]/[another[@"height"] floatValue];
    CGFloat imageAndUIRatio = (width- imageItemSpacing*2) / ([one[@"width"] floatValue] + ([another[@"width"] floatValue] * twoImageRatio)) ;
    CGSize oneRealSize = CGSizeMake([one[@"width"] floatValue]*imageAndUIRatio, [one[@"height"] floatValue]*imageAndUIRatio);
    return oneRealSize.height;
}

+ (CGFloat)calculateThreeImageItemWithOne:(NSDictionary*)one another:(NSDictionary*)another  thirdOne:(NSDictionary*) thirdOne  uiWidht:(CGFloat)width imageItemSpacing:(CGFloat)imageItemSpacing{
    CGFloat twoImageRatio = [one[@"height"] floatValue]/[another[@"height"] floatValue];
    CGFloat twoImageRatio2 = [one[@"height"] floatValue]/[thirdOne[@"height"] floatValue];
    CGFloat imageAndUIRatio = (width- imageItemSpacing*3) / ([one[@"width"] floatValue] + ([another[@"width"] floatValue] * twoImageRatio)+ ([thirdOne[@"width"] floatValue] * twoImageRatio2)) ;
    CGSize oneRealSize = CGSizeMake([one[@"width"] floatValue]*imageAndUIRatio, [one[@"height"] floatValue]*imageAndUIRatio);
    return oneRealSize.height;
}
- (CGFloat)updateImageData:(NSArray*)data  uiWidht:(CGFloat)width{
    NSAssert(data, @"data must not be nil.");
    NSAssert(data.count>0, @"data count must > 0.");
    self.sourceImageData = data;
    [self.realImageData removeAllObjects];
    CGFloat uiHeight = 0;
    if(data.count == 1)
    {
        uiHeight = [self calculateOneImageItemWithOne:data[0] uiWidht:width];
        
    }
    else if (data.count == 2) {
        
        uiHeight =  [self calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width];
    }
    else if (data.count == 3) {
        CGFloat firstRatio = [data[0][@"height"] floatValue]/[data[0][@"width"] floatValue];
        CGFloat secondRatio = [data[1][@"height"] floatValue]/[data[1][@"width"] floatValue];
        CGFloat thirdRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
        if (firstRatio>1.0 && secondRatio>1.0 && thirdRatio>1.0) {
            uiHeight = [self calculateThreeImageItemWithOne:data[0] another:data[1] thirdOne:data[2] uiWidht:width];
        }
        else
        {
            CGFloat onelineHeight = [self calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width];
            uiHeight = [self calculateOneImageItemWithOne:data[2] uiWidht:width] + onelineHeight+self.imageItemSpacing;
        }
    }
    else if(data.count == 4){
        CGFloat onelineHeight = [self calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width];
         uiHeight = [self calculateTwoImageItemWithOne:data[2] another:data[3] uiWidht:width] + onelineHeight+self.imageItemSpacing;
    }
    else if (data.count == 5){
        CGFloat firstRatio = [data[0][@"height"] floatValue]/[data[0][@"width"] floatValue];
        CGFloat secondRatio = [data[1][@"height"] floatValue]/[data[1][@"width"] floatValue];
        CGFloat thirdRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
        CGFloat onelineHeight = 0.0;
         if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0) || (firstRatio >1.0&& thirdRatio>1.0)) {
             onelineHeight = [self calculateThreeImageItemWithOne:data[0] another:data[1] thirdOne:data[2] uiWidht:width];
             uiHeight = onelineHeight + [self calculateTwoImageItemWithOne:data[3] another:data[4] uiWidht:width]+self.imageItemSpacing;
             
         }
         else {
             onelineHeight = [self calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width];
             firstRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
             secondRatio = [data[3][@"height"] floatValue]/[data[4][@"width"] floatValue];
             thirdRatio = [data[4][@"height"] floatValue]/[data[4][@"width"] floatValue];
             if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0)  || (firstRatio >1.0&& thirdRatio>1.0)) {
                 
                 uiHeight = onelineHeight + [self calculateThreeImageItemWithOne:data[2] another:data[3] thirdOne:data[4] uiWidht:width] +self.imageItemSpacing;
                 
             }
             else {
                 uiHeight = onelineHeight + [self calculateTwoImageItemWithOne:data[2] another:data[3] uiWidht:width] + self.imageItemSpacing;
             }
             
             
         }
            
    }
    else if (data.count >= 6){
        CGFloat firstRatio = [data[0][@"height"] floatValue]/[data[0][@"width"] floatValue];
        CGFloat secondRatio = [data[1][@"height"] floatValue]/[data[1][@"width"] floatValue];
        CGFloat thirdRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
        CGFloat onelineHeight = 0.0;
        if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0)  || (firstRatio >1.0&& thirdRatio>1.0)) {
            onelineHeight = [self calculateThreeImageItemWithOne:data[0] another:data[1] thirdOne:data[2] uiWidht:width];
            firstRatio = [data[3][@"height"] floatValue]/[data[3][@"width"] floatValue];
            secondRatio = [data[4][@"height"] floatValue]/[data[4][@"width"] floatValue];
            thirdRatio = [data[5][@"height"] floatValue]/[data[5][@"width"] floatValue];
             if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0)  || (firstRatio >1.0&& thirdRatio>1.0)) {
                 uiHeight = onelineHeight + [self calculateThreeImageItemWithOne:data[3] another:data[4] thirdOne:data[5] uiWidht:width] +self.imageItemSpacing;
             } else {
                uiHeight = onelineHeight + [self calculateTwoImageItemWithOne:data[4] another:data[5] uiWidht:width] +self.imageItemSpacing;
            }
            
        }
        else {
            onelineHeight = [self calculateTwoImageItemWithOne:data[0] another:data[1] uiWidht:width];
            firstRatio = [data[2][@"height"] floatValue]/[data[2][@"width"] floatValue];
            secondRatio = [data[3][@"height"] floatValue]/[data[4][@"width"] floatValue];
            thirdRatio = [data[4][@"height"] floatValue]/[data[4][@"width"] floatValue];
            if ((firstRatio>1.0 && secondRatio>1.0 )|| (secondRatio >1.0&& thirdRatio>1.0)  || (firstRatio >1.0&& thirdRatio>1.0)) {
                
                uiHeight = onelineHeight + [self calculateThreeImageItemWithOne:data[2] another:data[3] thirdOne:data[4] uiWidht:width] +self.imageItemSpacing;
                
            }
            else {
                uiHeight = onelineHeight + [self calculateTwoImageItemWithOne:data[2] another:data[3] uiWidht:width] +self.imageItemSpacing;
            }
            
            
        }
        
    }
    [self.collectionView reloadData];

    return uiHeight + self.imageNumHeight;
}
- (CGFloat)calculateOneImageItemWithOne:(NSDictionary*)one   uiWidht:(CGFloat)width{

    CGFloat itemWidth = [one[@"width"] floatValue];
    CGFloat itemHeight = [one[@"height"] floatValue];
    CGSize realSize = CGSizeMake(width, width * (itemHeight/itemWidth));
    [self.realImageData addObject: [NSValue valueWithCGSize:realSize]];
    return realSize.height;
    
}
- (CGFloat)calculateTwoImageItemWithOne:(NSDictionary*)one another:(NSDictionary*)another  uiWidht:(CGFloat)width {
    CGFloat twoImageRatio = [one[@"height"] floatValue]/[another[@"height"] floatValue];
    CGFloat imageAndUIRatio = (width- self.imageItemSpacing*2) / ([one[@"width"] floatValue] + ([another[@"width"] floatValue] * twoImageRatio)) ;
    CGSize oneRealSize = CGSizeMake([one[@"width"] floatValue]*imageAndUIRatio, [one[@"height"] floatValue]*imageAndUIRatio);
    [self.realImageData addObject: [NSValue valueWithCGSize:oneRealSize]];
    
    CGSize anotherRealSize = CGSizeMake([another[@"width"] floatValue] *twoImageRatio *imageAndUIRatio , [another[@"height"] floatValue] * twoImageRatio *imageAndUIRatio);
    [self.realImageData addObject: [NSValue valueWithCGSize:anotherRealSize]];
    return oneRealSize.height;
}

- (CGFloat)calculateThreeImageItemWithOne:(NSDictionary*)one another:(NSDictionary*)another  thirdOne:(NSDictionary*)thirdOne  uiWidht:(CGFloat)width {
    CGFloat twoImageRatio = [one[@"height"] floatValue]/[another[@"height"] floatValue];
    CGFloat twoImageRatio2 = [one[@"height"] floatValue]/[thirdOne[@"height"] floatValue];
    CGFloat imageAndUIRatio = (width- self.imageItemSpacing*3) / ([one[@"width"] floatValue] + ([another[@"width"] floatValue] * twoImageRatio)+ ([thirdOne[@"width"] floatValue] * twoImageRatio2)) ;
    CGSize oneRealSize = CGSizeMake([one[@"width"] floatValue]*imageAndUIRatio, [one[@"height"] floatValue]*imageAndUIRatio);
    [self.realImageData addObject: [NSValue valueWithCGSize:oneRealSize]];
    
    CGSize anotherRealSize = CGSizeMake([another[@"width"] floatValue] *twoImageRatio *imageAndUIRatio , [another[@"height"] floatValue] * twoImageRatio *imageAndUIRatio);
    [self.realImageData addObject: [NSValue valueWithCGSize:anotherRealSize]];
    
    CGSize thirdRealSize = CGSizeMake([thirdOne[@"width"] floatValue] *twoImageRatio2 *imageAndUIRatio , [thirdOne[@"height"] floatValue] * twoImageRatio2 *imageAndUIRatio);
    [self.realImageData addObject: [NSValue valueWithCGSize:thirdRealSize]];
    
    return oneRealSize.height;
}

#pragma mark - UICollectionView DataSoure And Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.realImageData.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    if (cell.contentView.subviews.count == 0){
        UIImageView *imageView = [[UIImageView alloc] init];
        [cell.contentView addSubview:imageView];
        imageView.backgroundColor = [UIColor brownColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray* imageViewConstraints = [NSMutableArray arrayWithCapacity:0];
        
        [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [cell.contentView  addConstraints:imageViewConstraints];
    }
    
    UIImageView * imageView = [cell.contentView.subviews objectAtIndex:0];
    self.imageLoader(imageView,[self.sourceImageData objectAtIndex:indexPath.row]);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //return CGSizeMake((collectionView.bounds.size.width-2*self.imageItemSpacing)/3, 100);
    //return CGSizeMake(collectionView.bounds.size.width, 200);
    CGSize size = [self.realImageData[indexPath.row] CGSizeValue];
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.imageItemSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.imageItemSpacing;
}

#pragma mark - lazy loading

- (UICollectionView *)collectionView {
    if (!_collectionView){
        UICollectionViewFlowLayout *collectionLayout=[[UICollectionViewFlowLayout alloc] init];
        [collectionLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        collectionLayout.headerReferenceSize = CGSizeMake(0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.delegate = self;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _collectionView;
}

- (UILabel*)imageNumLabel {
    if (!_imageNumLabel){
        _imageNumLabel = [[UILabel alloc] init];
        _imageNumLabel.textAlignment = NSTextAlignmentCenter;
        _imageNumLabel.backgroundColor = [UIColor whiteColor];
        _imageNumLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _imageNumLabel.textColor = [UIColor orangeColor];
        _imageNumLabel.font = [UIFont systemFontOfSize:12];
    }
    return _imageNumLabel;
}


@end
