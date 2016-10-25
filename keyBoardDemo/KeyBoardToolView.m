//
//  KeyBoardToolView.m
//  keyBoardDemo
//
//  Created by Gaoming on 16/10/25.
//  Copyright © 2016年 Gaoming. All rights reserved.
//

#import "KeyBoardToolView.h"

@implementation KeyBoardToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    UIButton *photo = [UIButton buttonWithType:UIButtonTypeCustom];
    photo.frame = CGRectMake(5, 5, 40, 40);
    [photo setTitle:@"图片" forState:UIControlStateNormal];
    [photo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [photo addTarget:self action:@selector(photoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _phohoBtn = photo;
    [self addSubview:_phohoBtn];
    
    UIButton *facial = [UIButton buttonWithType:UIButtonTypeCustom];
    facial.frame = CGRectMake(50, 5, 40, 40);
    [facial setTitle:@"表情" forState:UIControlStateNormal];
    [facial setTitle:@"文字" forState:UIControlStateSelected];
    [facial setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [facial addTarget:self action:@selector(emojiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _facialBtn = facial;
    [self addSubview:_facialBtn];
}

- (void)photoBtnAction
{
    NSLog(@"点击发送图片");
    if ([_delegate respondsToSelector:@selector(photoBtnClick)]) {
        [_delegate photoBtnClick];
    }
}

- (void)emojiBtnAction:(UIButton *)btn
{
    NSLog(@"点击表情或者文字");
    btn.selected = !btn.selected;
    if ([_delegate respondsToSelector:@selector(facialBtnClick:)]) {
        [_delegate facialBtnClick:btn];
    }
}

@end
