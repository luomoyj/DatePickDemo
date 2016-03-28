//
//  YJDateSheetView.m
//  DatePickDemo
//
//  Created by d-engine on 16/3/25.
//
//

#import "YJDateSheetView.h"
#import "YJDateManager.h"

@interface YJDateSheetView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrPickerDataSource;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *arrDays;
@property (nonatomic, strong) NSArray *arrHours;
@property (nonatomic, strong) NSArray *arrMinutes;

@property (nonatomic, copy) YJObjBlock blockSelectedDict;

@property (nonatomic, assign) NSInteger oneCompoentIndex;
@property (nonatomic, assign) NSInteger secondCompoentIndex;
@property (nonatomic, assign) NSInteger thirdCompoentIndex;

@end

@implementation YJDateSheetView

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (id)initWithFrame:(CGRect)frame pickerDataSource:(NSArray *)arrDataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        self.oneCompoentIndex = self.secondCompoentIndex = self.thirdCompoentIndex = 0;
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.arrPickerDataSource = [NSMutableArray array];
    self.arrDays = [kYJDateManager sevenDaysInfoFromToday];
    self.arrHours = [self arrHours];
    self.arrMinutes = [self arrMinutes];
    [self.arrPickerDataSource addObject:self.arrDays];
    [self.arrPickerDataSource addObject:self.arrHours];
    [self.arrPickerDataSource addObject:self.arrMinutes];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 52)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5)];
    topLineView.backgroundColor = [UIColor grayColor];
    [topView addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 51, CGRectGetWidth(self.frame), 0.5)];
    bottomLineView.backgroundColor = [UIColor grayColor];
    [topView addSubview:bottomLineView];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 90, 10, 85, 31)];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    btnRight.layer.cornerRadius = 10;
    btnRight.layer.borderWidth = 1;
    btnRight.layer.borderColor = [UIColor redColor].CGColor;
    [btnRight setTitle:@"确定" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(btnOKPressedAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnRight];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(topView.frame), CGRectGetWidth(self.frame), 210)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pickerView selectRow:1 inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:1 inComponent:0];
        [self.pickerView selectRow:8 inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:8 inComponent:1];
    });
}

-(void)setSelectedDicBlock:(YJObjBlock)block{
    _blockSelectedDict = block;
}

-(void)setSelectIndex:(NSUInteger)index{
    index = MIN(index, [self pickerView:_pickerView numberOfRowsInComponent:0]-1);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_pickerView selectRow:index inComponent:0 animated:NO];
    });
}

- (NSArray *)arrHours
{
    NSMutableArray *arrHours = [NSMutableArray array];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:[NSDate date]];
    NSInteger hour = components.hour;
    
    NSMutableArray *arrHoursAll = [NSMutableArray array];
    NSMutableArray *arrHoursFromNow = [NSMutableArray array];
    for (NSInteger i = hour; i < 24; i ++) {
        [arrHoursFromNow addObject:[NSString stringWithFormat:@"%@时", @(i)]];
    }
    
    for (NSInteger i = 0; i < 24; i ++) {
        [arrHoursAll addObject:[NSString stringWithFormat:@"%@时", @(i)]];
    }
    
    //当天的小时数组
    [arrHours addObject:arrHoursFromNow];
    //所有的小时数组
    [arrHours addObject:arrHoursAll];
    //NSLog(@"%@", arrHours);
    return arrHours;
}

- (NSArray *)arrMinutes
{
    NSMutableArray *arrMinutes = [NSMutableArray array];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:[NSDate date]];
    NSInteger minute = components.minute;
    
    NSMutableArray *arrMinutesAll = [NSMutableArray array];
    NSMutableArray *arrMinutesFromNow = [NSMutableArray array];
    //分钟之间相隔5分钟
    if (minute >= 55) {
        for (NSInteger i = minute; i < 60; i ++) {
            [arrMinutesFromNow addObject:[NSString stringWithFormat:@"%@分", @(i)]];
        }
    }
    else {
        for (NSInteger i = minute / 5 + 1; i < 60 / 5; i ++) {
            [arrMinutesFromNow addObject:[NSString stringWithFormat:@"%@分", @(i * 5)]];
        }
    }
    
    for (NSInteger i = 0; i < 60 / 5; i++) {
        [arrMinutesAll addObject:[NSString stringWithFormat:@"%@分", @(i * 5)]];
    }
    //当天的分钟数组
    [arrMinutes addObject:arrMinutesFromNow];
    //全部的分钟数组
    [arrMinutes addObject:arrMinutesAll];
    return arrMinutes;
}

#pragma mark -
-(void)btnOKPressedAction:(UIButton *)sener{
    CGSize size = [self.pickerView rowSizeForComponent:0];
    NSLog(@"%@", NSStringFromCGSize(size));

    if (_blockSelectedDict) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (int i=0; i<_pickerView.numberOfComponents; i++) {
            NSInteger num = [_pickerView selectedRowInComponent:i];
            [dic setObject:[NSNumber numberWithInteger:num] forKey:[NSString stringWithFormat:@"%d",i]];
            if (i == 0) {
                [dic setObject:self.arrPickerDataSource[0][1][num] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            else if (i == 1) {
                [dic setObject:self.arrPickerDataSource[i][self.secondCompoentIndex][num] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            else if (i == 2) {
                [dic setObject:self.arrPickerDataSource[i][self.thirdCompoentIndex][num] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
        _blockSelectedDict(dic);
    }

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, CGRectGetHeight(self.superview.frame), CGRectGetWidth(self.superview.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    id firstObject = [_arrPickerDataSource firstObject];
    if(!firstObject) return 0;
    if ([firstObject isKindOfClass:[NSArray class]]) {
        return [_arrPickerDataSource count];
    } else {
        return 1;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    id anObject;
    if (component == 0) {
        anObject = _arrPickerDataSource[component][self.oneCompoentIndex];
    }
    else if (component == 1) {
        anObject = _arrPickerDataSource[component][self.secondCompoentIndex];
    }
    else if (component == 2) {
        anObject = _arrPickerDataSource[component][self.thirdCompoentIndex];
    }
    if(!anObject) return 0;
    
    return [anObject count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    id anObject;
    if (component == 0) {
        anObject = _arrPickerDataSource[component][0];
    }
    else if (component == 1) {
        anObject = _arrPickerDataSource[component][self.secondCompoentIndex];
    }
    else if (component == 2) {
        anObject = _arrPickerDataSource[component][self.thirdCompoentIndex];
    }
    return anObject[row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.arrPickerDataSource.count == 3) {
        if (component == 0) {
            return CGRectGetWidth(self.frame) / self.arrPickerDataSource.count + 60;
        }
        else if (component == 1) {
            return CGRectGetWidth(self.frame) / self.arrPickerDataSource.count - 40;
        }
        else if (component == 2) {
            return CGRectGetWidth(self.frame) / self.arrPickerDataSource.count - 20;
        }
    }
    return CGRectGetWidth(self.frame) / self.arrPickerDataSource.count;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0 && row == 0) {
        //变动第一列时，第二列和第三列都变到第0行
        self.secondCompoentIndex = 0;
        self.thirdCompoentIndex = 0;
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
        [self.pickerView reloadAllComponents];
    }
    else if (component == 0 && row != 0) {
        //变动非第一列时，第二列变到第八行，第三列变到第0行(可以根据需求自己改)
        self.secondCompoentIndex = 1;
        self.thirdCompoentIndex = 1;
        [self.pickerView selectRow:8 inComponent:1 animated:NO];
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
        [self.pickerView reloadAllComponents];
    }
    else if (component == 1 && row == 0) {
        NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
        if (selectedRow == 0) {
            self.thirdCompoentIndex = 0;
        }
        else {
            self.thirdCompoentIndex = 1;
        }
        [self.pickerView reloadComponent:2];
    }
    else if (component == 1 && row != 0) {
        self.thirdCompoentIndex = 1;
        [self.pickerView reloadComponent:2];
    }
}



@end
