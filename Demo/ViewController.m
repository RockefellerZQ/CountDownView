//
//  ViewController.m
//  Demo
//
//  Created by aoliday on 15/8/4.
//  Copyright (c) 2015年 aoliday. All rights reserved.
//

#import "ViewController.h"
#import "ZQCountDownView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ZQCountDownView *countDownView;
@property (weak, nonatomic) IBOutlet ZQCountDownView *countDownView1;
@property (weak, nonatomic) IBOutlet ZQCountDownView *countDownView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _countDownView.circularCorner = YES;
    _countDownView.themeColor = [UIColor orangeColor];
    _countDownView.countDownTimeInterval = 2000;
    _countDownView.recoderTimeIntervalDidInBackground = YES;
    
    _countDownView1.themeColor = [UIColor magentaColor];
    _countDownView1.textColor = [UIColor whiteColor];
    _countDownView1.textFont = [UIFont systemFontOfSize:18];
    _countDownView1.countDownTimeInterval = 3000;
    
    _countDownView2.themeColor = [UIColor whiteColor];
    _countDownView2.textColor = [UIColor darkGrayColor];
    _countDownView2.textFont = [UIFont boldSystemFontOfSize:20];
    _countDownView2.colonColor = [UIColor whiteColor];
    _countDownView2.countDownTimeInterval = 4000;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
