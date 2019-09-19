//
//  ViewController.m
//  test
//
//  Created by weiguang on 2019/7/1.
//  Copyright © 2019 duia. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"


@interface ViewController ()

@property (nonatomic,strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 88, 100, 50)];
    [self.view addSubview:self.btn];
    self.btn.backgroundColor = [UIColor redColor];
    [self.btn setTitle:@"按钮" forState:UIControlStateNormal];
    
    GALLog(@"测试一下1");
    GALLog(@"测试一下2");
    GALLog(@"测试一下3");
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
    NSLog(@"－－－%@",[NSThread callStackSymbols]);
}

@end
