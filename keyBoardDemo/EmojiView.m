//
//  EmojiView.m
//  keyBoardDemo
//
//  Created by Gaoming on 16/10/24.
//  Copyright © 2016年 Gaoming. All rights reserved.
//

#import "EmojiView.h"
#import "EmojiCollectionViewCell.h"

@interface EmojiView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSDictionary *dataDict;
@end

@implementation EmojiView

- (instancetype)initWithFrame:(CGRect)frame source:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataDict = [NSDictionary dictionaryWithDictionary:dic];
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(40, 40);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 5, 5, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:NSClassFromString(@"EmojiCollectionViewCell") forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text = [_dataDict[@"People"] objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = _dataDict[@"People"];
    return arr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(emojiClick:)]) {
        [_delegate emojiClick:[_dataDict[@"People"] objectAtIndex:indexPath.row]];
    }
}

@end
