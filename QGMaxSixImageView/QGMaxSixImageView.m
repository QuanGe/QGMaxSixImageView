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
@property (strong,nonatomic) NSArray *realImageData;

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


- (void)updateImageData:(NSArray*)data imageSizes:(NSArray *)imageSizes {
    self.sourceImageData = data;
    self.realImageData =imageSizes;
    [self.collectionView reloadData];
    
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
