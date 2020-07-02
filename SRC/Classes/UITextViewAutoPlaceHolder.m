//
//  MTFormInputItemTextView.m
//  TestProject
//
//  Created by mt-lzg on 2020/6/11.
//  Copyright © 2020 Maitian. All rights reserved.
//

#import "UITextViewAutoPlaceHolder.h"

@interface UITextViewAutoPlaceHolder ()<UITextViewDelegate>

@property (nonatomic,weak) UILabel *placeHolderLabel;

@end

@implementation UITextViewAutoPlaceHolder

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.22];
    placeHolderLabel.font = self.font;
    placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    placeHolderLabel.text = @"请输入";
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:placeHolderLabel];
    _placeHolderLabel = placeHolderLabel;
    
    __weak typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidBeginEditingNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (weakSelf) {
            if (weakSelf.isFirstResponder) {
                [weakSelf textViewDidBeginEditing:weakSelf];
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidEndEditingNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (weakSelf) {
            if (weakSelf.isFirstResponder) {
                [weakSelf textViewDidEndEditing:weakSelf];
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (weakSelf) {
            if (weakSelf.isFirstResponder) {
                [weakSelf textViewDidChange:weakSelf];
            }
        }
    }];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolderLabel.text = placeHolder;
    CGRect frame = self.placeHolderLabel.frame;
    frame.size.height = [self.placeHolderLabel sizeThatFits:CGSizeMake(self.frame.size.width-5, 0)].height;
    self.placeHolderLabel.frame = frame;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textViewDidChange:self];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeHolderLabel.font = self.font;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolderLabel.hidden = textView.text.length;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeHolderLabel.hidden = textView.text.length;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.placeHolderLabel.hidden = textView.text.length;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeHolderLabel.frame = CGRectMake(self.textContainerInset.left, self.textContainerInset.top, self.frame.size.width, self.placeHolderLabel.font.lineHeight);
}

@end
