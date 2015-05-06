//
//  MyWorkContentVC.m
//  cmm
//
//  Created by Hcat on 15/4/15.
//
//

#import "MyWorkContentVC.h"
#import "MyWorkCollectionCell.h"
#import "Menu.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "ShareFun.h"

#import "TaskListVC.h"

@interface MyWorkContentVC ()<UICollectionViewDelegateFlowLayout>

@end

@implementation MyWorkContentVC


#pragma mark - viewLift
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[MyWorkCollectionCell class] forCellWithReuseIdentifier:@"MyWorkCollectionCell"];
    
   
   
}

-(void)viewWillAppear:(BOOL)animated{
    if (_arr_item == nil || [_arr_item count] == 0) {
        _lb_info.hidden = NO;
    }

}

#pragma mark - private methods 


#pragma mark - UICollectionViewDataSource 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.arr_item count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"MyWorkCollectionCell";
    MyWorkCollectionCell *cell = (MyWorkCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (self.arr_item != nil && [self.arr_item count] != 0) {
        Menu *t_menu = _arr_item[indexPath.row];
        cell.lb_content.text = t_menu.menuName;
        [cell.imageV_icon sd_setImageWithURL:[ShareFun fileUrlFormPath:t_menu.menuIcon] placeholderImage:[UIImage imageNamed:@"工作台_图标_移动网点认证.png"]];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    
    Menu *t_menu = _arr_item[indexPath.row];
    
    if ([t_menu.menuName isEqualToString:@"走访任务"]) {
        TaskListVC *t_vc = [[TaskListVC alloc] init];
        UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
        [ApplicationDelegate.viewController presentViewController:t_nav animated:YES completion:nil];
    }
    
}

#pragma mark - dealloc 

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
