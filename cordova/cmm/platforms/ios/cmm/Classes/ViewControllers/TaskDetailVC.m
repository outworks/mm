//
//  TaskDetailVC.m
//  cmm
//
//  Created by ilikeido on 15-3-31.
//
//

#import "TaskDetailVC.h"
#import "ChannelCell.h"

@interface TaskDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@property (weak, nonatomic) IBOutlet UILabel *lb_type;

@property(nonatomic,strong) NSArray *channels;


@end

@implementation TaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadDatas{
    
}

- (IBAction)startTask:(id)sender {
    
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChannelCell class])];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"TaskCell" owner:self options:nil];
        cell = [array lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell. = [_list objectAtIndex:indexPath.row];
    return cell;
}

@end
