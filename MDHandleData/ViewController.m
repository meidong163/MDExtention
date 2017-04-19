//
//  ViewController.m
//  MDHandleData
//
//  Created by 没懂 on 17/3/30.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "ViewController.h"
#import "MDInsertDataVC.h"
#import "MDShowDBDataVC.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *array;
@end

@implementation ViewController


- (NSArray *)array
{
    return @[
             @"插入数据",
             @"取出数据"
             ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];

}

#pragma --mark datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ViewControllerID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.textLabel.text = self.array[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MDInsertDataVC *insertVc = [MDInsertDataVC new];
        [self.navigationController pushViewController:insertVc animated:YES];
    }else
    {
        [self.navigationController pushViewController:[MDShowDBDataVC new] animated:YES];
    }
}

@end
