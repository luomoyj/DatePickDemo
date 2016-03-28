//
//  YJDateManager.h
//  DatePickDemo
//
//  Created by d-engine on 16/3/25.
//
//

#define kYJDateManager [YJDateManager shared]

#import <Foundation/Foundation.h>

@interface YJDateManager : NSObject

+ (instancetype)shared;
- (NSArray *)sevenDaysInfoFromToday;
- (NSString *)strWeekFromDate:(NSDate *)date;
- (NSString *)strWeekFromStrDate:(NSString *)strDate;

@end
