//
//  TaskSearchVC.m
//  cmm
//
//  Created by ilikeido on 15-4-4.
//
//

#import "TaskSearchVC.h"
#import "THDatePickerViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "NSDate+Helper.h"

@interface TaskSearchVC ()<THDatePickerDelegate>

@property(nonatomic,strong) THDatePickerViewController *datePicker;

@property (weak, nonatomic) IBOutlet UITextField *tf_name;

@property (weak, nonatomic) IBOutlet UIButton *btn_all;

@property (weak, nonatomic) IBOutlet UIButton *btn_nobegin;

@property (weak, nonatomic) IBOutlet UIButton *btn_begining;

@property (weak, nonatomic) IBOutlet UIButton *btn_finish;

@property (weak, nonatomic) IBOutlet UIButton *btn_timeout;

@property (weak, nonatomic) IBOutlet UIButton *btn_stop;

@property (weak, nonatomic) IBOutlet UIButton *btn_state_normal;

@property (weak, nonatomic) IBOutlet UIButton *btn_state_propaganda;

@property (weak, nonatomic) IBOutlet UIButton *btn_business;

@property (weak, nonatomic) IBOutlet UIButton *btn_starttime;

@property (weak, nonatomic) IBOutlet UIButton *btn_endtime;

@end

@implementation TaskSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.extendedLayoutIncludesOpaqueBars = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)stateChooseAction:(UIButton *)sender{
    NSInteger tag = sender.tag;
    NSString *tagString = [NSString stringWithFormat:@"%ld",(long)tag];
    self.state = tagString;
}

-(IBAction)typeChooseAction:(UIButton *)sender{
    NSInteger tag = sender.tag;
    NSString *tagString = [NSString stringWithFormat:@"%ld",(long)tag];
    self.typeId = tagString;
}

- (IBAction)startTimeAction:(id)sender {
    [self initDatePicker];
    NSDate *date = nil;
    if (_startTime.length > 0) {
        date = [NSDate dateFromString:_startTime withFormat:@"yyyy-MM-dd"];
    }
    [self showDatePicker:1 date:date];
}

- (IBAction)endTimeAction:(id)sender {
    [self initDatePicker];
    NSDate *date = nil;
    if (_endTime.length > 0) {
        date = [NSDate dateFromString:_endTime withFormat:@"yyyy-MM-dd"];
    }
    [self showDatePicker:2 date:date];
}

-(void)initDatePicker{
    if(!self.datePicker){
        self.datePicker = [THDatePickerViewController datePicker];
        self.datePicker.delegate = self;
        [self.datePicker setAllowClearDate:NO];
        [self.datePicker setClearAsToday:YES];
        [self.datePicker setAutoCloseOnSelectDate:NO];
        [self.datePicker setAllowSelectionOfSelectedDate:YES];
        [self.datePicker setDisableHistorySelection:NO];
        [self.datePicker setDisableFutureSelection:YES];
        //[self.datePicker setAutoCloseCancelDelay:5.0];
        [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
        [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
        [self.datePicker setCurrentDateColorSelected:[UIColor yellowColor]];
        
        [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
            int tmp = (arc4random() % 30)+1;
            return (tmp % 5 == 0);
        }];
    }

}

-(void)showDatePicker:(int)tag date:(NSDate *)date{
    self.datePicker.tag = tag;
    self.datePicker.date = date;
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(1.0),
                                                                  }];
}




- (IBAction)searchAction:(id)sender {
    _name = _tf_name.text;
    if (_delegate && [_delegate respondsToSelector:@selector(searchName:state:typeId:startTime:endTime:)]) {
        [_delegate searchName:self.name state:self.state typeId:self.typeId startTime:self.startTime endTime:self.endTime];
    }
}


- (IBAction)clearAction:(id)sender {
    self.startTime = nil;
    self.endTime = nil;
    self.state = nil;
    self.typeId = nil;
}


-(void)setStartTime:(NSString *)startTime{
    _startTime = startTime;
    [self.btn_starttime setTitle:_startTime forState:UIControlStateNormal];
}

-(void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    [self.btn_endtime setTitle:endTime forState:UIControlStateNormal];
}

-(void)setName:(NSString *)name{
    _name = name;
    [_tf_name setText:name];
}

-(void)setTypeId:(NSString *)typeId{
    if (![typeId isEqual:_typeId]) {
        UIButton *oldBtn = [self btnWithTypeId:_typeId];
        [self setBtnNormalStyle:oldBtn];
        UIButton *newBtn = [self btnWithTypeId:typeId];
        [self setBtnSelectedStyle:newBtn];
    }else{
        UIButton *oldBtn = [self btnWithTypeId:_typeId];
        [self setBtnNormalStyle:oldBtn];
        typeId = nil;
    }
    _typeId = typeId;
}

-(void)setState:(NSString *)state{
    if (![state isEqual: _state]) {
        UIButton *oldBtn = [self btnWithState:_state];
        [self setBtnNormalStyle:oldBtn];
        UIButton *newBtn = [self btnWithState:state];
        [self setBtnSelectedStyle:newBtn];
    }else{
        UIButton *oldBtn = [self btnWithState:_state];
        [self setBtnNormalStyle:oldBtn];
        state = nil;
    }
    _state = state;
}

-(UIButton *)btnWithTypeId:(NSString *)typeId{
    int tag = 0;
    if (typeId) {
        tag = [typeId intValue];
    }
    UIButton *btn;
    switch (tag) {
        case 1:
            btn = _btn_state_normal;
            break;
        case 2:
            btn = _btn_state_propaganda;
            break;
        case 3:
            btn = _btn_business;
            break;
        default:
            break;
    }
    return btn;
}

-(UIButton *)btnWithState:(NSString *)state{
    int tag = 0;
    if (state) {
        tag = [state intValue];
    }
    UIButton *btn;
    switch (tag) {
        case 0:
            btn = _btn_all;
            break;
        case 1:
            btn = _btn_nobegin;
            break;
        case 2:
            btn = _btn_begining;
            break;
        case 3:
            btn = _btn_finish;
            break;
        case 4:
            btn = _btn_timeout;
            break;
        case 5:
            btn = _btn_stop;
            break;
        default:
            break;
    }
    return btn;
}

-(void)setBtnNormalStyle:(UIButton *)btn{
    [btn setImage:[UIImage imageNamed:@"订单_表单_复选框_未选中"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
}

-(void)setBtnSelectedStyle:(UIButton *)btn{
    [btn setImage:[UIImage imageNamed:@"订单_表单_复选框_选中"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (IBAction)backAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(taskSearchVCBack:)] ){
        [_delegate taskSearchVCBack:self];
    }
}

#pragma mark - THDatePickerDelegate

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    NSString *dateString = [datePicker.date stringWithFormat:@"yyyy-MM-dd"];
    if (datePicker.tag == 1) {
        self.startTime = dateString;
    }else{
        self.endTime = dateString;
    }
    NSLog(@"%@",datePicker.date);
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    //[self.datePicker slideDownAndOut];
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
//    NSLog(@"Date selected: %@",[_formatter stringFromDate:selectedDate]);
}


@end
