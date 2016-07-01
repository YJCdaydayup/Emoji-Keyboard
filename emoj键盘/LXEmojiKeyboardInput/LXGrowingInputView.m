//
//  AppDelegate.m
//  emoj键盘
//
//  Created by 杨力 on 30/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//
#import "LXGrowingInputView.h"
#import "Masonry.h"

@interface LXGrowingInputView()<UITextViewDelegate>

@property (assign, nonatomic) CGFloat contentHeight;


@property (strong, nonatomic, readonly) NSBundle * assetBundle;

@end

@implementation LXGrowingInputView
@synthesize textView = _textView, leftButton = _leftButton, rightButton = _rightButton;

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _assetBundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [self.assetBundle pathForResource:@"LXEmojiKeyboardInput" ofType:@"bundle"];
    if (bundlePath) {
        _assetBundle = [NSBundle bundleWithPath:bundlePath];
    }

    _keyboardType = LXKeyboardTypeDefault;
    
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.textView];
    [self addSubview:self.addButton];

    [self setupViewConstraints];
}

- (void) setupViewConstraints {
    
    UIImage * bgImage = [UIImage imageWithContentsOfFile:[self.assetBundle pathForResource:@"inputview_background@2x" ofType:@"png"]];
    UIImageView * bgView = [[UIImageView alloc] initWithImage:bgImage];
    [self addSubview:bgView];
    [self sendSubviewToBack:bgView];

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(5);
        make.bottom.equalTo(self).with.offset(-8);
        make.width.mas_equalTo(40);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addButton.mas_left).with.offset(-3
                                                                );
        make.bottom.equalTo(self).with.offset(-8);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(28);

    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftButton.mas_right).offset(5);
        make.right.equalTo(self.rightButton.mas_left).offset(-5);
        make.bottom.equalTo(self).offset(-5);
        make.top.equalTo(self).offset(5);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.rightButton.mas_right).offset(3);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo(self.rightButton);
        make.width.mas_equalTo(self.rightButton);
        make.bottom.mas_equalTo(self.rightButton.mas_bottom);
    }];
    
    
}

#pragma mark - Setter and getter
- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        _textView.bounces = NO;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.font = [UIFont systemFontOfSize:15.0f];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.cornerRadius = 5.0;
        _textView.layer.borderWidth = 1.0;
        _textView.layer.borderColor =  [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    }
    return _textView;
}


- (void)setContentHeight:(CGFloat)contentHeight {
    
    if (_contentHeight == contentHeight) {
        return;
    }
    
    _contentHeight = contentHeight;

    //加上 上下间距
    CGFloat allHeight = _contentHeight + 10.0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:willChangeHeight:)]) {
        [self.delegate inputView:self willChangeHeight:allHeight];
    }
}

- (UIButton *)leftButton
{
    if (!_leftButton)
    {
        _leftButton = [[UIButton alloc] init];
        UIImage * norImage = [UIImage imageWithContentsOfFile:[self.assetBundle pathForResource:@"keyboard_btn_default@2x" ofType:@"png"]];
        UIImage * hlImage = [UIImage imageWithContentsOfFile:[self.assetBundle pathForResource:@"keyboard_btn_emoji@2x" ofType:@"png"]];
        [_leftButton setImage:norImage forState:UIControlStateNormal];
        [_leftButton setImage:hlImage forState:UIControlStateSelected];
        _leftButton.translatesAutoresizingMaskIntoConstraints = NO;
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_leftButton addTarget:self action:@selector(keyboardTypeChangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton)
    {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightButton.translatesAutoresizingMaskIntoConstraints = NO;
        _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
        _rightButton.layer.cornerRadius = 3.0;
        _rightButton.clipsToBounds = YES;
        [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightButton.backgroundColor = [UIColor orangeColor];
        [_rightButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightButton;
}

- (UIButton *)addButton
{
    if (!_addButton)
    {
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _addButton.translatesAutoresizingMaskIntoConstraints = NO;
        _addButton.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
        _addButton.layer.cornerRadius = 3.0;
        _addButton.clipsToBounds = YES;
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addButton.backgroundColor = [UIColor orangeColor];
        [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addButton;
}

#pragma mark - Event response
- (void)sendButtonClick:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didInputViewSendButtonClick:)]) {
        [_delegate didInputViewSendButtonClick:self];
    }

}

- (void)keyboardTypeChangeButtonClick:(UIButton *)sender {
    
    if (_textView.isFirstResponder) {
        sender.selected = !sender.selected;
        _keyboardType = sender.selected ? LXKeyboardTypeEmoji : LXKeyboardTypeDefault;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:keyboardChangeButtonClick:keyboardType:)]) {
        [_delegate inputView:self keyboardChangeButtonClick:sender keyboardType:_keyboardType];
    }
    
}

//右边新增的按钮
-(void)addButtonClick:(UIButton *)sender{
    
    if (_textView.isFirstResponder) {
        sender.selected = !sender.selected;
        _keyboardType = sender.selected ? YLKeyboardTypeAdd : LXKeyboardTypeDefault;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:keyboardChangeYLButtonClick:keyboardType:)]) {
        [_delegate inputView:self keyboardChangeYLButtonClick:sender keyboardType:_keyboardType];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    NSString * curText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    NSLog(@"%@", curText);
    
    if ([text isEqualToString:@"\n"]) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(didInputViewSendButtonClick:)]) {
            [_delegate didInputViewSendButtonClick:self];
        }
        
        return NO;
    }
    
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView {
    
    self.contentHeight = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)].height;
    
    /*解决编辑的时候，光标位置异常的问题*/
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        [textView setContentOffset:offset];
    }
    /*end*/
}

@end
