//
//  ViewController.m
//  ActionSheet
//
//  Created by Mervyn on 17/1/23.
//  Copyright © 2017年 mervyn_lbl@163.com. All rights reserved.
//

#import "ViewController.h"
#import "BLActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    BLActionSheet *actionSheet = [[BLActionSheet alloc] initWithTitle:@"ActionSheet" message:@"custom actionsgeet" actionSheetStyle:BLActionSheetStyleFlat];
    // 设置标题文字和颜色
    [actionSheet setValue:[UIColor blueColor] forKey:@"sheetTitleColor"];
//    [actionSheet setValue:[UIFont systemFontOfSize:16] forKey:@"sheetTitleFont"];
//    [actionSheet setValue:[UIColor blueColor] forKey:@"sheetMessageColor"];
//    [actionSheet setValue:[UIFont systemFontOfSize:12] forKey:@"sheetMessageFont"];
//    [actionSheet setValue:[UIColor blueColor] forKey:@"sheetCancelColor"];
//    [actionSheet setValue:[UIFont systemFontOfSize:15] forKey:@"sheetTitleFont"];
    
    
    /**
     *  ActionTitle  主标题
     *  subTitle     副标题
     *  image        图片名称
     */
    
    BLAction *actionOne = [[BLAction alloc] initWithActionTitle:@"Camera" subTitle:@"take photo" image:nil action:^(BLActionSheet *actionSheet) {
        
        NSLog(@"NSLog one");
    }];
    // 设置标题文字和颜色
//    [actionOne setValue:[UIColor redColor] forKey:@"actionTitleColor"];
//    [actionOne setValue:[UIFont systemFontOfSize:15] forKey:@"actionTitleFont"];
    [actionOne setValue:[UIColor redColor] forKey:@"actionMessageColor"];
//    [actionOne setValue:[UIFont systemFontOfSize:15] forKey:@"actionMessageFont"];
    
    BLAction *actionTwo = [[BLAction alloc] initWithActionTitle:@"Photo Album" subTitle:@"Use your phone picture" image:nil action:^(BLActionSheet *actionSheet) {
        
        NSLog(@"NSLog two");
    }];
    
    // 单个加入
//    [actionSheet addAction:actionOne];
//    [actionSheet addAction:actionTwo];
    
    // 批量加入
    [actionSheet addActions:@[actionOne,actionTwo]];
    
    [actionSheet presentActionSheet];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
