//
//  YJDateManager.m
//  DatePickDemo
//
//  Created by d-engine on 16/3/25.
//
//

#import "YJDateManager.h"

@interface YJDateManager ()

@property (nonatomic, strong) NSArray *arrWeeks;

@end

@implementation YJDateManager

+ (instancetype)shared
{
    static YJDateManager *dateManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateManager = [[YJDateManager alloc] init];
    });
    return dateManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrWeeks = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    }
    return self;
}

- (NSArray *)sevenDaysInfoFromToday
{
    
    NSMutableArray *arrSevenDaysYearDay = [self sevenDaysYearDayFromToday];
    //    arrSevenDaysYearDay[0][0] = @"今天";
    //    arrSevenDaysYearDay[0][1] = @"明天";
    //    arrSevenDaysYearDay[0][2] = @"后天";
    
    //    NSMutableArray *arrTmp = [NSMutableArray array];
    //    [arrSevenDaysYearDay[0] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        [arrTmp addObject:[NSString stringWithFormat:@"%@(%@)", obj, self.arrWeeks[(idx + 2) % 7]]];
    //    }];
    //    NSLog(@"arrtmp:%@", arrTmp);
    return arrSevenDaysYearDay;
}

- (NSMutableArray *)sevenDaysYearDayFromToday
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSDate *beginningOfWeek;
    NSMutableArray *arrDays = [NSMutableArray array];
    NSMutableArray *arrDaysWithYear = [NSMutableArray array];
    NSMutableArray *arrDaysWithNoYear = [NSMutableArray array];
    
    NSString *weekDay = [self strWeekFromDate:[NSDate date]];
    NSInteger index = [self.arrWeeks indexOfObject:weekDay];
    NSLog(@"index:%@", @(index));
    
    for (NSInteger i = 0; i < 7; i ++) {
        components.year = components.year;
        components.month = components.month;
        if (i == 0) {
            [components setDay:[components day]];
        }
        else {
            [components setDay:([components day]+1)];
        }
        NSLog(@"%@,%@,%@", @(components.year), @(components.month), @(components.day));
        
        NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
        beginningOfWeek = [gregorian dateFromComponents:components];
        
        if (i == 0) {
            [arrDaysWithNoYear addObject:[NSString stringWithFormat:@"%@(%@)", @"今天", self.arrWeeks[(index + i) % 7]]];
        }
        else if (i == 1) {
            [arrDaysWithNoYear addObject:[NSString stringWithFormat:@"%@(%@)", @"明天", self.arrWeeks[(index + i) % 7]]];
        }
        else if (i == 2) {
            [arrDaysWithNoYear addObject:[NSString stringWithFormat:@"%@(%@)", @"后天", self.arrWeeks[(index + i) % 7]]];
        }
        else {
            [dateday setDateFormat:@"MM月dd日"];
            [arrDaysWithNoYear addObject:[NSString stringWithFormat:@"%@(%@)", [dateday stringFromDate:beginningOfWeek], self.arrWeeks[(index + i) % 7]]];
        }
        
        [dateday setDateFormat:@"yyyy-MM-dd"];
        NSLog(@"%@", beginningOfWeek);
        [arrDaysWithYear addObject:[dateday stringFromDate:beginningOfWeek]];
    }
    [arrDays addObject:arrDaysWithNoYear];
    [arrDays addObject:arrDaysWithYear];
    return arrDays;
}

- (NSString *)yearDayFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return [NSString stringWithFormat:@"%@月%@日", @(components.month), @(components.day)];
}

- (NSString *)strWeekFromStrDate:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [self strWeekFromDate:[dateFormatter dateFromString:strDate]];
}

- (NSString *)strWeekFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger weekIndex = components.weekday;
    return self.arrWeeks[weekIndex - 1];
}

-(NSString *)compareDate:(NSDate *)date{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday, *afterTomorrow;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    afterTomorrow = [today dateByAddingTimeInterval:secondsPerDay * 2];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString *afterTomorrowString = [[afterTomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else if ([dateString isEqualToString:afterTomorrowString]) {
        return @"后天";
    }
    else
    {
        return dateString;
    }
}

@end
