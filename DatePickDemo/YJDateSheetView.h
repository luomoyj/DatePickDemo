//
//  YJDateSheetView.h
//  DatePickDemo
//
//  Created by d-engine on 16/3/25.
//
//

#import <UIKit/UIKit.h>

typedef void (^YJObjBlock)(id obj);

@interface YJDateSheetView : UIView

- (id)initWithFrame:(CGRect)frame pickerDataSource:(NSArray *)arrDataSource;

-(void)setSelectedDicBlock:(YJObjBlock)block;

@end
