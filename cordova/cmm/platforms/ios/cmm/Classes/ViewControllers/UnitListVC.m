//
//  UnitListVC.m
//  cmm
//
//  Created by ilikeido on 15/4/19.
//
//

#import "UnitListVC.h"
#import "UnitCell.h"
#import "TaskExecutionVC.h"

@interface UnitListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UnitListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Unit *unit = [_units objectAtIndex:indexPath.row];
    if ([unit.isTask isEqual:@"1"]) {
        Task *task = [unit.task firstObject];
        TaskExecutionVC *vc = [[TaskExecutionVC alloc]init];
        vc.unit = unit;
        vc.taskId = task.id;
        vc.taskName = task.name;
        vc.opetypeid = task.opetypeid;
        [self.navigationController pushViewController:vc animated:YES ];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 97.0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _units.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UnitCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UnitCell class])];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"UnitCell" owner:self options:nil];
        cell = [array lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.unit = [_units objectAtIndex:indexPath.row];
    return cell;
}


@end
