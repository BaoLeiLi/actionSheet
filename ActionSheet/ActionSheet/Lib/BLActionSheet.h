//
//  BLActionSheet.h
//  wannasg
//
//  Created by Mervyn on 16/12/19.
//  Copyright © 2016年 mervyn_lbl@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLAction.h"

#define SheetColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

typedef enum{
    
    BLActionSheetStyleFlat = 0,
    BLActionSheetStyleRound,
    BLActionSheetStyleDefult = BLActionSheetStyleFlat  // defult
    
}BLActionSheetStyle;

static const char *customActionSheetKey = "lbl.customActionSheetKey";

@interface BLActionSheet : UIView
/**
 *  init a actionSheet object
 *  @param  title: sheet title;defult size of font is 16,color defult is (r,g,b)->(102,102,102)
 *  @param  message: add description for sheet title;defult size of font is 13,color defult is (r,g,b)->(180,180,180)
 *  @param style: sheet show style
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actionSheetStyle:(BLActionSheetStyle)style;
/**
 *  push sheet
 */
- (void)presentActionSheet;
/**
 *  add a action object
 */
- (void)addAction:(BLAction *)action;
/**
 *  add multi action object
 */
- (void)addActions:(NSArray <BLAction *>*)actions;

@end
