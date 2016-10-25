//
//  EmojiCollectionViewCell.m
//  keyBoardDemo
//
//  Created by Gaoming on 16/10/24.
//  Copyright © 2016年 Gaoming. All rights reserved.
//

#import "EmojiCollectionViewCell.h"

@implementation EmojiCollectionViewCell

- (void)layoutSubviews
{
    [self.contentView addSubview:_label];
//    [self.contentView addSubview:_deleteIv];
    self.backgroundColor = [UIColor yellowColor];
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _label.font = [UIFont systemFontOfSize:30];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIImageView *)deleteIv
{
    if (!_deleteIv) {
        _deleteIv = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    }
    return _deleteIv;
}

@end
