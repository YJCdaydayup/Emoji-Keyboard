//
//  AppDelegate.m
//  emoj键盘
//
//  Created by 杨力 on 30/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXEmojiKeyboardView : UIView<UIInputViewAudioFeedback>

@property (nonatomic,assign) id<UITextInput>textView;

@property (strong, nonatomic, readonly) UIScrollView * scrollView;
@property (strong, nonatomic, readonly) UIPageControl * pageControl;

@property (strong, nonatomic) UIImage * deleteNormalImage;
@property (strong, nonatomic) UIImage * deleteHlightedImage;
@property (assign, nonatomic) NSInteger rowCount;
@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger bottomEdgeSpacing;
@property (assign, nonatomic) NSInteger horizontalEdgeSpacing;

//新增相册，摄像头等等
@property (nonatomic,strong) UIScrollView * addButtonScrollView;

+ (id) keybaordViewWithFrame:(CGRect)frame;

/*! 刷新界面 */
- (void) layoutAllButtons;

@end
