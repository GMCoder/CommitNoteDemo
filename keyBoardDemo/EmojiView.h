//
//  EmojiView.h
//  keyBoardDemo
//
//  Created by Gaoming on 16/10/24.
//  Copyright © 2016年 Gaoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiViewDelegate <NSObject>

- (void)emojiClick:(NSString *)emoji;

@end

@interface EmojiView : UIView

@property (nonatomic, weak) id <EmojiViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame source:(NSDictionary *)dic;

@end
