//
//  ViewController.m
//  test
//
//  Created by weiguang on 2019/7/1.
//  Copyright © 2019 duia. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "Persion.h"
#import <NSLogger.h>

@interface ViewController ()

@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) Persion *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 88, 100, 50)];
    [self.view addSubview:self.btn];
    self.btn.backgroundColor = [UIColor redColor];
    [self.btn setTitle:@"按钮" forState:UIControlStateNormal];
    
    GALLog(@"测试一下");
   // [self test2];
    
    LoggerApp(1,@"Hello world! Today is:%@",[NSDate date]);
    LoggerNetwork(1,@"Hello world! Today is:%@",[NSDate date]);
}



#pragma mark - 'CGRectDivide' 使用方法
- (void)test2 {
    
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




- (IBAction)btnClick:(id)sender {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    BOOL isAdd = YES;
    NSLog(@"跳过第一行");
    
    self.btn.backgroundColor = [UIColor blueColor];
    static int count = 0;
    if (isAdd) {
        count = count + 1;
    } else {
        count = count - 2;
    }
    GALLog(@"count is %d",count);
    
    [self demo1];
    
}


- (void)demo1 {
    [self demo2];
}

- (void)demo2 {
   // NSLog(@"－－－%@",[NSThread callStackSymbols]);
    
    /*
     * 此方法可以在子线程销毁对象
     */
    self.person = [[Persion alloc] init];
    Persion *tmp = self.person;
    self.person = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [tmp class];
    });

}


@end
