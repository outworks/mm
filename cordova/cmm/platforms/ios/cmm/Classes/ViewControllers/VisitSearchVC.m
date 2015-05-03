//
//  VisitSearchVC.m
//  cmm
//
//  Created by Hcat on 15/4/22.
//
//

#import "VisitSearchVC.h"
#import "THDatePickerViewController.h"
#import "NSDate+Helper.h"

@interface VisitSearchVC ()

@property(nonatomic,strong) THDatePickerViewController *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *btn_starttime;

@property (weak, nonatomic) IBOutlet UIButton *btn_endtime;





@end

@implementation VisitSearchVC

#pragma mark - viewLift
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btn_starttime setTitle:_startTime forState:UIControlStateNormal];
    [self.btn_endtime setTitle:_endTime forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - set&&get 

-(void)setStartTime:(NSString *)startTime{
    _startTime = startTime;
    [self.btn_starttime setTitle:_startTime forState:UIControlStateNormal];
}

-(void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    [self.btn_endtime setTitle:endTime forState:UIControlStateNormal];
}

#pragma mark - privateMethods 

-(void)initDatePicker{
    if(!self.datePicker){
        self.datePicker = [THDatePickerViewController datePicker];
        self.datePicker.delegate = (id<THDatePickerDelegate>)self;
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


#pragma mark - buttonAction 

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

- (IBAction)searchAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(searchstartTime:endTime:)]) {
        [_delegate searchstartTime:self.startTime endTime:self.endTime];
    }
}


- (IBAction)clearAction:(id)sender {
    self.startTime = nil;
    self.endTime = nil;
    
}

- (IBAction)backAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(VisitSearchVCBack:)] ){
        [_delegate VisitSearchVCBack:self];
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


#pragma mark  - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
