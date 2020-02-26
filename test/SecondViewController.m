//
//  SecondViewController.m
//  TextureDemo
//
//  Created by weiguang on 2019/7/1.
//  Copyright © 2019 duia. All rights reserved.
//

#import "SecondViewController.h"


@interface SecondViewController ()

@property (nonatomic,strong) UILabel *timeLab;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupBackBtn];
}


- (void)setupBackBtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 20)];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.textColor = [UIColor redColor];
    _timeLab.text = @"00:00:00";
    [self.view addSubview:_timeLab];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self timeCutDown:@"2020-02-26 16:30:00"];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
   
}


// 获取倒计时
- (void)timeCutDown:(NSString *)createAtStr {
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createDate = [fmt dateFromString:createAtStr];
    //4 计算当前时间和创建时间的时间差
    NSDate *nowDate = [NSDate date];
    __block int interval = [createDate timeIntervalSinceDate:nowDate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    __block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (interval <= 0) { //倒计时关闭
            dispatch_source_cancel(timer);
            timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"倒计时结束");
            });
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getDetailTimeWithTimestamp:interval];
                interval--;
            });
        }
    });
    dispatch_resume(timer);
    
}

// 传秒要*1000，传m毫秒就不用
- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp
{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    NSInteger day = ms/dd;
    NSInteger hour = (ms - day * dd)/hh;
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    NSLog(@"%zd日:%zd时:%zd分:%zd秒",day,hour,minute,second);
    _timeLab.text = [NSString stringWithFormat:@"%zd日:%zd时:%zd分:%zd秒",day,hour,minute,second];
}

- (void)shareToApp {
    NSString *textToShare = @"要分享的文本内容";
     UIImage *imageToShare = [UIImage imageNamed:@"iosshare"];
    // NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];

     NSArray *activityItems = @[textToShare, imageToShare];
     UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
     [self presentViewController:activityVC animated:YES completion:nil];
     
     UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
             if (completed){
                 NSLog(@"completed");
             }
         };
     activityVC.completionWithItemsHandler = myBlock;
}



@end
