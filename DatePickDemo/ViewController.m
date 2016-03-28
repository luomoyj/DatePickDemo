//
//  ViewController.m
//  DatePickDemo
//
//  Created by d-engine on 16/3/25.
//
//

#import "ViewController.h"
#import "YJDateSheetView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 30, CGRectGetMidY(self.view.frame) - 10, 60, 20)];
    [btn setTitle:@"press" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(btnPressedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnPressedAction:(UIButton *)btn
{
    NSLog(@"111");
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    YJDateSheetView *sheetView = [[YJDateSheetView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(window.frame), CGRectGetWidth(window.frame), 262) pickerDataSource:nil];
    [sheetView setSelectedDicBlock:^(NSDictionary *obj) {
        NSLog(@"%@", obj);
    }];
    [window addSubview:sheetView];
    
    [UIView animateWithDuration:0.25 animations:^{
        sheetView.frame = CGRectMake(0, CGRectGetHeight(window.frame) - 262, CGRectGetWidth(window.frame), 262);
    } completion:^(BOOL finished) {
        
    }];
}

@end
