//
//  WaitEvallluatViewController.m
//  maYiChaoFeng
//
//  Created by Android on 2017/4/14.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import "WaitEvallluatViewController.h"
#import "WaitEvaluateTableViewCell.h"
#import "GoodsOrderModel.h"
#import "OrderDataTool.h"
#import "UIView+FPErrorPage.h"
@interface WaitEvallluatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSoure;
@end

@implementation WaitEvallluatViewController
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"WaitEvaluateTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellId"];
        
    }
    return _tableView;
}
-(NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [[NSMutableArray alloc]init];
        
    }
    return _dataSoure;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self getDataWithPage:@"0"];
}
-(void)getDataWithPage:(NSString *)page{
    [OrderDataTool getOrderWithStatus:@"0" page:page success:^(id responseObject) {
        MYLog(@"获取待评价订单列表返回%@",responseObject);
        self.dataSoure= [GoodsOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        if (self.dataSoure.count==0) {
            [self.tableView showBlankPageView];
        }
        else{
            [self.tableView hideBlankPageView];
        }
    } failure:^(NSError *error) {
        MYLog(@"获取待评价订单列表错误%@",error);
    }];
}

#pragma mark -----------------UITableViewDelegate-----------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    WaitEvaluateTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.model=self.dataSoure[indexPath.section];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsOrderModel *model=self.dataSoure[indexPath.section];
    return 64+(80*model.goods.count);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
@end
