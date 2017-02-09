//
//  BLAction.h
//  wannasg
//
//  Created by Mervyn on 16/12/19.
//  Copyright © 2016年 mervyn_lbl@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLActionSheet;

typedef void (^actionBlock)(BLActionSheet *actionSheet);

struct BLStruct{
    
    CGFloat x;
    CGFloat width;
};

typedef struct BLStruct BLStruct;

@interface BLAction : UIView
/**
 *  init a action object
 *  @param title:  execute intention;defult size of font is 16,color defult is (r,g,b)->(34,34,34)
 *  @param subTitle:    add description for title,defult size of font is 13,color defult is (r,g,b)->(180,180,180)
 *  @param image:   add image show at title left
 *  @param handle:  execute method
 */
- (instancetype)initWithActionTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)imageName action:(actionBlock)handle;

@end
