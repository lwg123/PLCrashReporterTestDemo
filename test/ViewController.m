//
//  ViewController.m
//  test
//
//  Created by weiguang on 2019/7/1.
//  Copyright © 2019 duia. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import <CrashReporter/CrashReporter.h>


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupUI];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(jumpToSecondController)];
    
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(startMonitor)];
}



#pragma mark - 'CGRectDivide' 使用方法
- (void)setupUI {
    
    void (^addGrid)(CGRect) = ^(CGRect frame) {
        UIView *grid = [[UIView alloc] initWithFrame:frame];
        grid.backgroundColor = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
        grid.layer.borderWidth = 0.5;
        [self.view addSubview:grid];
    };
    
    CGFloat gridWidth = 40.0, gridHeight = 30.0;
    NSInteger numberOfRow = 10, numberOfColumn = 8;
    CGRect slice1, rowRemainder, columnRemainder;
    rowRemainder = self.view.bounds;
    for (int i = 0; i < numberOfRow; i++) { //行
        CGRectDivide(rowRemainder, &slice1, &rowRemainder, gridHeight, CGRectMinYEdge);
        columnRemainder = slice1;
        for (int j = 0; j < numberOfColumn; j++) { //列
            CGRectDivide(columnRemainder, &slice1, &columnRemainder, gridWidth, CGRectMinXEdge);
            addGrid(slice1);
        }
    }
    
}


- (void)jumpToSecondController {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark --摇一摇功能
//让当前控制器成为第一响应者，只有这样才能接收事件，所以此段代码必须加到控制器中
- (BOOL)canBecomeFirstResponder
{
    return YES; // default is NO
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇动手机");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"结束");
    if (motion == UIEventSubtypeMotionShake) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"Lookin功能列表" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"导出为 Lookin 文档" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"进入 2D 模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"进入 3D 模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消");
}



@end
