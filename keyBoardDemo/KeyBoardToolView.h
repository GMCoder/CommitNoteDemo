//
//  KeyBoardToolView.h
//  keyBoardDemo
//
//  Created by Gaoming on 16/10/25.
//  Copyright © 2016年 Gaoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardToolViewDelegate <NSObject>

@required
- (void)photoBtnClick;

- (void)facialBtnClick:(UIButton *)btn;

@end

@interface KeyBoardToolView : UIView

@property (nonatomic, strong) UIButton *phohoBtn;
@property (nonatomic, strong) UIButton *facialBtn;
@property (nonatomic, weak) id <KeyBoardToolViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
