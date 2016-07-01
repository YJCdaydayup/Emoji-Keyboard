//
//  AppDelegate.m
//  emoj键盘
//
//  Created by 杨力 on 30/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXGrowingInputView;

typedef NS_ENUM(NSInteger, LXKeyboardType) {
    LXKeyboardTypeDefault,
    LXKeyboardTypeEmoji,
    //新增一种类型
    YLKeyboardTypeAdd,
};


@protocol LXGrowingInputViewDelegate <NSObject>

@optional

- (void)inputView:(LXGrowingInputView *)inputView willChangeHeight:(float)height;
- (void)inputView:(LXGrowingInputView *)inputView keyboardChangeButtonClick:(UIButton *)button keyboardType:(LXKeyboardType)type;
- (void)didInputViewSendButtonClick:(LXGrowingInputView *)inputView;

-(void)inputView:(LXGrowingInputView *)inputView keyboardChangeYLButtonClick:(UIButton *)ylButton keyboardType:(LXKeyboardType)type;


@end

@interface LXGrowingInputView : UIView

@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UIButton *rightButton;
@property (nonatomic, strong, readonly) UITextView *textView;
@property (nonatomic,strong) UIButton * addButton;

@property (weak, nonatomic) id<LXGrowingInputViewDelegate> delegate;

@property (assign, nonatomic, readonly) LXKeyboardType keyboardType;



@end
