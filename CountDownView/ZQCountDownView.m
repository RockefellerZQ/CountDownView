//
//  ZQCountDownView.m
//  ZQCountDownView
//
//  Created by aoliday on 15/7/7.
//  Copyright (c) 2015年 aoliday. All rights reserved.
//

#import "ZQCountDownView.h"

@interface ZQCountDownView ()

//显示小时
@property (nonatomic) UILabel *hourLabel;
// 显示分钟
@property (nonatomic) UILabel *minuteLabel;
// 显示秒
@property (nonatomic) UILabel *secondLabel;

// 显示时间的冒号集合， 可以更改这个集合内冒号的颜色， 字体等
@property (nonatomic) NSArray *colonsArray;

@property (nonatomic) NSTimer *timer;
// 用于展示的秒， 分钟， 小时
@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int minute;
@property (nonatomic, assign) int second;

@property (nonatomic, assign) BOOL didRegisterNotificaton;

// 进入后台时since 1970的秒数
@property (nonatomic, assign) NSTimeInterval endBackgroundTimeInterval;
// 当前倒计时剩余秒数
@property (nonatomic, assign) NSTimeInterval countDownLeftTimeInterval;


// 设置小时重新设置label的frame，小时默认两位数，可能超过两位数
- (void)setHourText:(NSString *)hour;

@end

@implementation ZQCountDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeValues];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeValues];
    }
    return self;
}

- (void)initializeValues
{
    _themeColor = [UIColor clearColor];
    _colonColor = [UIColor darkTextColor];
    _textColor = [UIColor darkTextColor];
    _textFont = [UIFont systemFontOfSize:14.0];
    _recoderTimeIntervalDidInBackground = NO;
    _didRegisterNotificaton = NO;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self adjustSubViewsWithFrame:frame];
}

- (void)setRecoderTimeIntervalDidInBackground:(BOOL)recoderTimeIntervalDidInBackground
{
    _recoderTimeIntervalDidInBackground = recoderTimeIntervalDidInBackground;
    if (recoderTimeIntervalDidInBackground)
    {
        [self observeNotification];
    }
    
    if (!recoderTimeIntervalDidInBackground && _didRegisterNotificaton)
    {
        [self removeObservers];
    }
}

/**
 *  调整时分秒的frame
 *
 */
- (void)adjustSubViewsWithFrame:(CGRect)frame
{
    if (!self.hourLabel.superview)
    {
        [self addSubview:self.hourLabel];
    }
    
    if (!self.minuteLabel.superview)
    {
        [self addSubview:self.minuteLabel];
    }
    
    if (!self.secondLabel.superview)
    {
        [self addSubview:self.secondLabel];
    }
    
    [_hourLabel sizeToFit];
    CGFloat hourLabelWidth = _hourLabel.frame.size.width;
    CGFloat width = frame.size.width;
    CGFloat colonWidth = 8.0;
    CGFloat itemWidth = (width - colonWidth * 2) / 3;
    if (hourLabelWidth < itemWidth)
    {
        hourLabelWidth = itemWidth;
    }
    itemWidth = (width - hourLabelWidth - colonWidth * 2) / 2;
    CGFloat itemHeight = frame.size.height;
    
    // 如果存在colon view的话先将colon view 移除当前视图
    if (_colonsArray.count > 0)
    {
        for (UIView *subView in _colonsArray)
        {
            [subView removeFromSuperview];
        }
    }
    
    UILabel *colonOne = [[UILabel alloc] initWithFrame:CGRectMake(hourLabelWidth, 0, colonWidth, itemHeight)];
    colonOne.text = @":";
    colonOne.backgroundColor = [UIColor clearColor];
    colonOne.textColor = _colonColor;
    colonOne.font = _textFont;
    colonOne.textAlignment = NSTextAlignmentCenter;
    [self addSubview:colonOne];
    
    UILabel *colonTwo = [[UILabel alloc] initWithFrame:CGRectMake(hourLabelWidth + itemWidth + colonWidth, 0, colonWidth, itemHeight)];
    colonTwo.text = @":";
    colonTwo.backgroundColor = [UIColor clearColor];
    colonTwo.textColor = _colonColor;
    colonTwo.font = _textFont;
    colonTwo.textAlignment = NSTextAlignmentCenter;
    [self addSubview:colonTwo];
    
    _colonsArray = @[colonOne, colonTwo];
    colonOne = nil;
    colonTwo = nil;
    
    _hourLabel.frame = CGRectMake(0, 0, hourLabelWidth, itemHeight);
    _minuteLabel.frame = CGRectMake(CGRectGetMaxX(_hourLabel.frame) + colonWidth, 0, itemWidth, itemHeight);
    _secondLabel.frame = CGRectMake(CGRectGetMaxX(_minuteLabel.frame) + colonWidth, 0, itemWidth, itemHeight);
}

- (void)setHourText:(NSString *)hour
{
    NSInteger texeLength = _hourLabel.text.length;
    _hourLabel.text = hour;
    if (texeLength != _hourLabel.text.length)
    {
        [self adjustSubViewsWithFrame:self.frame];
    }
}

#pragma mark init subviews
- (UILabel *)hourLabel
{
    if (!_hourLabel)
    {
        _hourLabel = [UILabel new];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.backgroundColor = _themeColor;
        _hourLabel.textColor = _textColor;
        _hourLabel.font = _textFont;
        _hourLabel.layer.cornerRadius = 4;
        _hourLabel.clipsToBounds = YES;
        _hourLabel.text = @"00";
    }
    return _hourLabel;
}

- (UILabel *)minuteLabel
{
    if (!_minuteLabel)
    {
        _minuteLabel = [UILabel new];
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        _minuteLabel.backgroundColor = _themeColor;
        _minuteLabel.textColor = _textColor;
        _minuteLabel.font = _textFont;
        _minuteLabel.layer.cornerRadius = 4;
        _minuteLabel.clipsToBounds = YES;
        _minuteLabel.text = @"00";
    }
    return _minuteLabel;
}

- (UILabel *)secondLabel
{
    if (!_secondLabel)
    {
        _secondLabel = [UILabel new];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.backgroundColor = _themeColor;
        _secondLabel.textColor = _textColor;
        _secondLabel.font = _textFont;
        _secondLabel.layer.cornerRadius = 4;
        _secondLabel.clipsToBounds = YES;
        _secondLabel.text = @"00";
    }
    return _secondLabel;
}

#pragma mark set property value
- (void)setThemeColor:(UIColor *)themeColor
{
    if (_themeColor != themeColor)
    {
        _themeColor = themeColor;
        _minuteLabel.backgroundColor = themeColor;
        _secondLabel.backgroundColor = themeColor;
        _hourLabel.backgroundColor = themeColor;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor)
    {
        _textColor = textColor;
        _minuteLabel.textColor = textColor;
        _secondLabel.textColor = textColor;
        _hourLabel.textColor = textColor;
    }
}

- (void)setTextFont:(UIFont *)textFont
{
    if (_textFont != textFont)
    {
        _textFont = textFont;
        _secondLabel.font = textFont;
        _minuteLabel.font = textFont;
        _hourLabel.font = textFont;
        if (_colonsArray.count > 0)
        {
            for (UILabel *label in _colonsArray)
            {
                label.font = textFont;
            }
        }
    }
}

- (void)setColonColor:(UIColor *)colonColor
{
    if (_colonColor != colonColor)
    {
        _colonColor = colonColor;
        if (_colonsArray.count > 0)
        {
            for (UILabel *label in _colonsArray)
            {
                label.textColor = colonColor;
            }
        }
    }
}

- (void)setCountDownTimeInterval:(NSTimeInterval)countDownTimeInterval
{
    _countDownTimeInterval = countDownTimeInterval;
    if (_countDownTimeInterval < 0)
    {
        _countDownTimeInterval = 0;
    }
    _second = (int)_countDownTimeInterval % 60;
    _minute = ((int)_countDownTimeInterval / 60) % 60;
    _hour = _countDownTimeInterval / 3600;
     [self setHourText:[NSString stringWithFormat:@"%02d", _hour]];
    _minuteLabel.text = [NSString stringWithFormat:@"%02d", _minute];
    _secondLabel.text = [NSString stringWithFormat:@"%02d", _second];
    if (_countDownTimeInterval > 0 && !_timer)
    {
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//        [self.timer fire];
    }
}

- (void)setLabelBorderColor:(UIColor *)labelBorderColor {
    _hourLabel.layer.borderColor = _minuteLabel.layer.borderColor = _secondLabel.layer.borderColor = labelBorderColor.CGColor;
    _hourLabel.layer.borderWidth = _minuteLabel.layer.borderWidth = _secondLabel.layer.borderWidth = 0.5;
}

- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(adjustCoundDownTimer:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)adjustCoundDownTimer:(NSTimer *)timer
{
    _countDownTimeInterval --;
    if (_minute == 0 && _hour > 0)
    {
        _hour -= 1;
        _minute = 60;
        [self setHourText:[NSString stringWithFormat:@"%02d", _hour]];
    }

    if (_second == 0 && _minute > 0)
    {
        _second = 60;
        if (_minute > 0)
        {
            _minute -= 1;
            _minuteLabel.text = [NSString stringWithFormat:@"%02d", _minute];
        }
    }
    
    if (_second > 0)
    {
        _second -= 1;
        _secondLabel.text = [NSString stringWithFormat:@"%02d", _second];
    }
    
    if (_second <= 0 && _minute <= 0 && _hour <= 0)
    {
        [_timer invalidate];
        _timer = nil;
        if (_delegate && [_delegate respondsToSelector:@selector(countDownDidFinished)]) {
            [_delegate countDownDidFinished];
        }
    }
}

- (void)stopCountDown
{
    [self removeObservers];
    [_timer invalidate];
    _timer = nil;
}

#pragma mark Observers and methods

- (void)observeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    _didRegisterNotificaton = YES;
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _didRegisterNotificaton = NO;
}

- (void)didInBackground:(NSNotification *)notification
{
    _endBackgroundTimeInterval = [[NSDate date] timeIntervalSince1970];
    _countDownLeftTimeInterval = _countDownTimeInterval;
}

- (void)willEnterForground:(NSNotification *)notification
{
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diff = currentTimeInterval - _endBackgroundTimeInterval;
    [self setCountDownTimeInterval:_countDownLeftTimeInterval - diff];
}

- (void)dealloc
{
    [self removeObservers];
    _textColor = nil;
    _textFont = nil;
    _themeColor = nil;
    _textFont = nil;
    _colonsArray = nil;
    _hourLabel = nil;
    _minuteLabel = nil;
    _secondLabel = nil;
}

@end
