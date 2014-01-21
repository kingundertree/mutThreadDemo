//
//  DIMainViewController.m
//  mutThreadDemo
//
//  Created by 夏至 on 14-1-21.
//  Copyright (c) 2014年 dooioo. All rights reserved.
//

#import "DIMainViewController.h"

#define IOS7_SDK_AVAILABLE 1

@interface DIMainViewController ()
@property (strong,nonatomic) DIAppDelegate *myDelegate;
@end

@implementation DIMainViewController

@synthesize strLab,lInt,timer,queue;
@synthesize myDelegate = _myDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"多线程";
	// Do any additional setup after loading the view.
    
    if (IOS7_SDK_AVAILABLE) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    self.myDelegate = (DIAppDelegate *)[[UIApplication sharedApplication] delegate];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 10, 65, 35);
    [btn1 addTarget:self action:@selector(nstd:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"NSThread" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(85, 10, 65, 35);
    [btn2 addTarget:self action:@selector(gcd:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"GCD" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:btn2];

    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(160, 10, 65, 35);
    [btn3 addTarget:self action:@selector(nsoq:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitle:@"nsoq" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(235, 10, 65, 35);
    [btn4 addTarget:self action:@selector(nsio:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setTitle:@"nsoq" forState:UIControlStateNormal];
    btn4.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(10, 55, 65, 35);
    [btn5 addTarget:self action:@selector(timerStop:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setTitle:@"timerStop" forState:UIControlStateNormal];
    btn5.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:btn5];

    self.strLab = [[UILabel alloc] init];
    self.strLab.text = @"0";
    self.strLab.frame = CGRectMake(10, 100, 300, 40);
    self.strLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.strLab];
}
-(void)nstd:(UIButton *)btn{
    NSLog(@"nstd-->>");
    lInt = 0;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)calcPlus:(NSThread *)nstd{
    NSLog(@"calcPlus");
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
-(void)timerStop:(UIButton *)btn{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
-(void)timerFired:(NSTimer *)timer{
    NSLog(@"lInt-->>%ld",lInt);
    lInt++;
    self.strLab.text = [NSString stringWithFormat:@"%ld",lInt];
}
-(void)gcd:(UIButton *)btn{
    NSLog(@"gcd");
//    //  后台执行：
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // something
//    });
//    // 主线程执行：
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // something
//    });
//    // 一次性执行：
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // code to be executed once
//    });
//    // 延迟2秒执行：
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        // code to be executed on the main queue after delay
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (long i = 0; i < 1000000000; i++) {
            NSLog(@"str-->>%@",[NSString stringWithFormat:@"gcdNum---->>%ld",i]);
//            self.strLab.text = [NSString stringWithFormat:@"gcdNum---->>%ld",i];
//            NSLog(@"i--->>%ld",i);
        }
    });
}

-(void)nsoq:(UIButton *)btn{
    NSLog(@"nsoq");
    queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(oqCalc:) object:nil];
    [queue addOperation:op];
}
-(void)oqCalc:(NSInvocationOperation *)op{
    for (long i = 0; i < 1000000000; i++) {
        NSLog(@"opstr-->>%@",[NSString stringWithFormat:@"gcdNum---->>%ld",i]);
        self.strLab.text = [NSString stringWithFormat:@"gcdNum---->>%ld",i];
        if (i == 10000) {
            [self performSelectorOnMainThread:@selector(oqDone) withObject:nil waitUntilDone:NO];

        }
    }
}
-(void)oqDone{
    NSLog(@"oqdone over");
}
-(void)nsio:(UIButton *)btn{
    NSLog(@"nsio");
    
    self.myDelegate = (DIAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"newWorld1-->>%@",self.myDelegate.worldStr);
    
    self.myDelegate.worldStr = [NSString stringWithFormat:@"change the word need a big mind"];
    NSLog(@"newWorld2-->>%@",self.myDelegate.worldStr);
    
    queue = [[NSOperationQueue alloc] init];

    NSInvocationOperation *theOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(ioCalc:) object:nil];
    [queue addOperation:theOp];
}
-(void)ioCalc:(NSInvocationOperation *)io{
    for (long i = 0; i < 1000000000; i++) {
        NSLog(@"str-->>%@",[NSString stringWithFormat:@"ioNum---->>%ld",i]);
        self.strLab.text = [NSString stringWithFormat:@"ioNum---->>%ld",i];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
