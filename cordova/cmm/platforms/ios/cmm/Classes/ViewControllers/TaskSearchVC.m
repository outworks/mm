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

@property(nonatomic,strong) NSMutableArray *typeids;

@property(nonatomic,strong) NSMutableArray *states;

@end

@implementation TaskSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_typeId.length > 0) {
        self.typeids = [[_typeId componentsSeparatedByString:@","]mutableCopy];
    }else{
        self.typeids = [[NSMutableArray alloc]init];
    }
    if (_state.length> 0) {
        self.states = [[_state componentsSeparatedByString:@","]mutableCopy];
    }else{
        self.states = [[NSMutableArray alloc]init];
    }
    [self upStateBtns];
    [self upTypeBtns];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)stateChooseAction:(UIButton *)sender{
    NSInteger tag = sender.tag;
    NSString *tagString = [NSString stringWithFormat:@"%ld",(long)tag];
    if ([self.states containsObject:tagString]) {
        [self.states removeObject:tagString];
    }else{
        [self.states addObject:tagString];
    }
    self.state = [self stateString];
}

//获取状态
-(NSString * )stateString{
   NSArray *temp = [self.states sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       NSString *s1 = obj1;
       NSString *s2 = obj2;
       return [s1 compare:s2 options:NSNumericSearch];
    }];
    return [temp componentsJoinedByString:@","];
}

-(NSString *)typeIdString{
    NSArray *temp = [self.typeids sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        return [s1 compare:s2 options:NSNumericSearch];
    }];
    return [temp componentsJoinedByString:@","];
}

-(IBAction)typeChooseAction:(UIButton *)sender{
    NSInteger tag = sender.tag;
    NSString *tagString = [NSString stringWithFormat:@"%ld",(long)tag];
    if ([self.typeids containsObject:tagString]) {
        [self.typeids removeObject:tagString];
    }else{
        [self.typeids addObject:tagString];
    }
    self.typeId = [self typeIdString];
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

-(void)upTypeBtns{
    for (int i=1; i<4; i++) {
        [self resetTypeBtn:i];
    }
}

-(void)upStateBtns{
    for (int i=1; i<6; i++) {
        [self resetStateBtn:i];
    }
}

-(void)setTypeId:(NSString *)typeId{
    [self upTypeBtns];
    _typeId = typeId;
}

-(void)setState:(NSString *)state{
    [self upStateBtns];
    _state = state;
}

-(UIButton *)btnWithTypeTag:(int)tag{
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

-(UIButton *)btnWithStateTage:(int)tag{
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

-(void)resetStateBtn:(int)tag{
    UIButton *btn = [self btnWithStateTage:tag];
    if ([_states containsObject:[NSString stringWithFormat:@"%d",tag]]) {
        [self setBtnSelectedStyle:btn];
    }else{
        [self setBtnNormalStyle:btn];
    }
}

-(void)resetTypeBtn:(int)tag{
    UIButton *btn = [self btnWithTypeTag:tag];
    if ([_typeids containsObject:[NSString stringWithFormat:@"%d",tag]]) {
        [self setBtnSelectedStyle:btn];
    }else{
        [self setBtnNormalStyle:btn];
    }
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
