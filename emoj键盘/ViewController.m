//
//  ViewController.m
//  emoj键盘
//
//  Created by 杨力 on 30/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ViewController.h"
#import "LXEmojiKeyboardView.h"
#import "LXGrowingInputView.h"
#import "Masonry.h"

@interface ViewController ()<LXGrowingInputViewDelegate>{
    
    BOOL _isTypeChanged;
}

@property (nonatomic,strong) LXEmojiKeyboardView * emojView;
@property (nonatomic,strong) LXGrowingInputView * inputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //emoj高度
    self.emojView = [[LXEmojiKeyboardView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    
    self.inputView = [[LXGrowingInputView alloc]init];
    self.inputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_inputView];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    _inputView.delegate = self;
}

#pragma mark -LXGrowingInputViewDelegate
//点击发送
-(void)didInputViewSendButtonClick:(LXGrowingInputView *)inputView{
    
    _isTypeChanged = NO;
    [inputView.textView resignFirstResponder];
}

//文字高度变化
-(void)inputView:(LXGrowingInputView *)inputView willChangeHeight:(float)height{
    
    if(height >100){
        
        return;
    }
    
    [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(height));
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
       
        [self.view layoutIfNeeded];
    }];
}

//左边按钮改变键盘的类型
-(void)inputView:(LXGrowingInputView *)inputView keyboardChangeButtonClick:(UIButton *)button keyboardType:(LXKeyboardType)type{
    
    _isTypeChanged = YES;
    NSTimeInterval duratin = 0.0f;
    if([inputView.textView isFirstResponder]){
        
        duratin = 0.006;
    }
    
    self.emojView.scrollView.hidden = NO;
    self.emojView.pageControl.hidden = NO;
    self.emojView.addButtonScrollView.hidden = YES;
    
    //先回收键盘，但frame不改变
    [inputView.textView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duratin * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(type == LXKeyboardTypeDefault){
            
            _emojView.textView = nil;
        }else{
            
            _emojView.textView = _inputView.textView;
        }
        
        [_inputView.textView reloadInputViews];
        [_inputView.textView becomeFirstResponder];
    });
}

//右边按钮改变键盘
-(void)inputView:(LXGrowingInputView *)inputView keyboardChangeYLButtonClick:(UIButton *)ylButton keyboardType:(LXKeyboardType)type{
    
    
    _isTypeChanged = YES;
    NSTimeInterval duratin = 0.0f;
    if([inputView.textView isFirstResponder]){
        
        duratin = 0.006;
    }
    
    self.emojView.scrollView.hidden = YES;
    self.emojView.pageControl.hidden = YES;
    self.emojView.addButtonScrollView.hidden = NO;
    
    //先回收键盘，但frame不改变
    [inputView.textView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duratin * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(type == LXKeyboardTypeDefault){
            
            _emojView.textView = nil;
        }else{
            
            _emojView.textView = _inputView.textView;
        }
        
        [_inputView.textView reloadInputViews];
        [_inputView.textView becomeFirstResponder];
    });
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self registerNotice];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self removeNotice];
}

#pragma mark -注册通知
-(void)registerNotice{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notice{
    
    NSDictionary * dict = [notice userInfo];
    //键盘的尺寸
    CGSize size = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    //键盘弹出需要的时间
    NSTimeInterval duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    CGFloat height = size.height;
    [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-height);
    }];
    
    //动画时间
    [UIView animateWithDuration:duration-0.5 animations:^{
       
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWillHide:(NSNotification *)notice{
    
    //如果键盘的类型改变，则不改变inputView的高度
    if(_isTypeChanged){
        
        return;
    }
    
    NSDictionary * dict = [notice userInfo];
    NSTimeInterval duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:duration animations:^{
       
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - 销毁通知
-(void)removeNotice{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
