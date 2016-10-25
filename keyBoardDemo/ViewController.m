//
//  ViewController.m
//  keyBoardDemo
//
//  Created by Gaoming on 16/10/22.
//  Copyright © 2016年 Gaoming. All rights reserved.
//

#import "ViewController.h"
#import "EmojiView.h"
#import "KeyBoardToolView.h"
#import <Photos/Photos.h>

@interface ViewController ()<UITextViewDelegate,EmojiViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KeyBoardToolViewDelegate>
{
    UIImagePickerController *_imagePickerVc;
}
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) KeyBoardToolView *toolView;
@property (nonatomic, assign) BOOL toolHide;
@property (nonatomic, strong) EmojiView *emojiView;
@property (nonatomic, strong) NSDictionary *emojiDict;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardPresent:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"======%@",[NSThread currentThread]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"-----%@",[NSThread currentThread]);
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        dispatch_async(dispatch_get_main_queue(), ^{
           self.emojiDict = [NSDictionary dictionaryWithDictionary:dict];
            self.emojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200) source:self.emojiDict];
            self.emojiView.delegate = self;
            [self.view addSubview:self.emojiView];
            NSLog(@"+++++%@",[NSThread currentThread]);
        });
    });
    
    [self configNav];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 68, self.view.frame.size.width, 50)];
    textField.placeholder = @"标题";
    textField.font = [UIFont systemFontOfSize:18];
    textField.tag = 5;
    self.textField = textField;
    [self.view addSubview:self.textField];
    
    CGRect leftFrame = self.textField.frame;
    leftFrame.size.width = 10;
    UIView *leftView = [[UIView alloc] initWithFrame:leftFrame];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 118, self.view.frame.size.width - 20, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    self.lineView = lineView;
    [self.view addSubview:self.lineView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 124, self.view.frame.size.width - 10, self.view.frame.size.height - 130) textContainer:nil];
    textView.tag = 10;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:18];
    self.textView = textView;
    [self.view addSubview:self.textView];
    
    UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 30)];
    placeholderLabel.font = [UIFont systemFontOfSize:18];
    placeholderLabel.text = @"内容";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel = placeholderLabel;
    [self.textView addSubview:placeholderLabel];
    
    self.toolView = [[KeyBoardToolView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    self.toolView.backgroundColor = [UIColor grayColor];
    self.toolView.delegate = self;
    [self.view addSubview:self.toolView];
}

- (void)configNav
{
    self.title = @"编辑";
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(releaseNote)];
    [rightBtn setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)releaseNote
{
    NSLog(@"发布帖子啦!!!!!!!!!!!");
    [self.view endEditing:YES];
}

- (void)setNavigationBarWithTitle:(NSString *)titleStr
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.title = titleStr;
    CGFloat fontCount = 18;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontCount],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

//- (void)keyboardWillChangeFrameNoti:(NSNotification *)noti
//{
//    NSLog(@"键盘将要更改frame%@",noti);
//    
//    BOOL isRet = self.textField.isEditing;
//    if (!isRet) {
//        CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        NSLog(@"%@",frame);
//        
//        CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        
//        [UIView animateWithDuration:duration animations:^{
//            
////            [self.view layoutIfNeeded];
//            
//        }];
//    }
//}

#pragma mark - toolViewDelegate

- (void)photoBtnClick
{
    NSLog(@"点击图片");
    _imagePickerVc = [[UIImagePickerController alloc] init];
    _imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerVc.delegate = self;
    _imagePickerVc.allowsEditing = YES;
    [self presentViewController:_imagePickerVc animated:YES completion:nil];
}

- (void)facialBtnClick:(UIButton *)btn
{
    self.toolHide = YES;
    if (btn.selected) {
        [self.view endEditing:YES];
    }else{
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - keyboardNoti
- (void)keyboardPresent:(NSNotification *)noti
{
    NSLog(@"弹出键盘%@",noti);
    self.toolView.facialBtn.selected = NO;
    BOOL isRet = self.textField.isEditing;
    CGRect endFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if (self.toolHide) {
        [UIView animateWithDuration:duration delay:0.0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.emojiView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        } completion:nil];
        if (isRet) {
            [UIView animateWithDuration:duration delay:0.0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
                self.toolView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
            } completion:nil];
        }else{
            [UIView animateWithDuration:duration delay:0.0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
                CGRect frame = self.toolView.frame;
                frame.origin.y = endFrame.origin.y - 50;
                self.toolView.frame = frame;
                
                CGRect textViewFrame = self.textView.frame;
                textViewFrame.size.height = self.view.frame.size.height - (endFrame.size.height + 50) - 124;
                self.textView.frame = textViewFrame;
            } completion:nil];
        }
    }else{
        if (!isRet) {
            [UIView animateWithDuration:duration delay:0.0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
                CGRect frame = self.toolView.frame;
                frame.origin.y = endFrame.origin.y - 50;
                self.toolView.frame = frame;
                
                CGRect textViewFrame = self.textView.frame;
                textViewFrame.size.height = self.view.frame.size.height - (endFrame.size.height + 50) - 124;
                self.textView.frame = textViewFrame;
            } completion:nil];
        }else{
            [UIView animateWithDuration:duration delay:0.0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
                self.toolView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
                self.textView.frame = CGRectMake(5, 124, self.view.frame.size.width - 10, self.view.frame.size.height - 130);
            } completion:nil];
        }
    }
    self.toolHide = NO;
}

- (void)keyboardDismiss:(NSNotification *)noti
{
    NSLog(@"键盘消失%@",noti);
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    BOOL isRet = self.textView.isFirstResponder;
    if (self.toolHide&&isRet) {
        if (self.textView.text.length == 0) {
            self.placeholderLabel.alpha = 1;
        }
        [UIView animateWithDuration:duration delay:0.0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.emojiView.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200);
            self.toolView.frame = CGRectMake(0, self.view.frame.size.height - 250, self.view.frame.size.width, 50);
            
            CGRect textViewFrame = self.textView.frame;
            textViewFrame.size.height -= 250;
            self.textView.frame = textViewFrame;
        } completion:nil];
    }else{
        [UIView animateWithDuration:duration delay:0.0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.toolView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
            self.textView.frame = CGRectMake(5, 124, self.view.frame.size.width - 10, self.view.frame.size.height - 130);
        } completion:nil];
    }
}

#pragma mark - emojiDelegate
- (void)emojiClick:(NSString *)emoji
{
    self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,emoji];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (!textView.text.length) {
        self.placeholderLabel.alpha = 1;
    } else {
        self.placeholderLabel.alpha = 0;
    }
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"选取图片%@",info);
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self appendImageOnTextViewWithImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)appendImageOnTextViewWithImage:(UIImage *)image
{
    self.textView.text = [NSString stringWithFormat:@"%@\r\n",self.textView.text];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText.mutableCopy];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = image;//要添加的图片
    textAttachment.bounds = CGRectMake(0, 0, 100, 100);
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
//    [string insertAttributedString:textAttachmentString atIndex:self.textView.text.length];//index为用户指定要插入图片的位置
    [string appendAttributedString:textAttachmentString];
    self.textView.attributedText = string;
    self.textView.font = [UIFont systemFontOfSize:18];
}

- (void)hideEmojiViewAndToolView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.toolView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
        self.emojiView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    }];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
