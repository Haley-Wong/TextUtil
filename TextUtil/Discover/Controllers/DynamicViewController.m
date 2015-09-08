//
//  DynamicViewController.m
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "DynamicViewController.h"

#import "DynamicCell.h"
#import "Dynamic.h"

@interface DynamicViewController ()

@property (nonatomic, strong) NSArray *dynamicData;

@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDynamicData];
}

- (void)loadDynamicData
{
    
    Dynamic *dynamic = [[Dynamic alloc] init];
    dynamic.isPraise = YES;
    dynamic.location = @"深圳市";
    dynamic.createTime = @"12:50";
    dynamic.type = 0;
    dynamic.text = @"山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？";
    dynamic.imageCount = 0;
    dynamic.replyCount = 66;
    [dynamic save];
    
    Dynamic *dynamic2 = [[Dynamic alloc] init];
    dynamic2.isPraise = YES;
    dynamic2.location = @"上海";
    dynamic2.createTime = @"昨天 10:11";
    dynamic2.type = 1;
    dynamic2.text = nil;
    dynamic2.imageCount = 1;
    dynamic2.replyCount = 188;
    [dynamic2 save];
    
    Dynamic *dynamic3 = [[Dynamic alloc] init];
    dynamic3.isPraise = YES;
    dynamic3.location = @"北京市";
    dynamic3.createTime = @"前天 10:11";
    dynamic3.type = 1;
    dynamic3.text = @"人的一生可能燃烧也可能腐朽，我不能腐朽，我愿意燃烧起来！";
    dynamic3.imageCount = 3;
    dynamic3.replyCount = 66;
    [dynamic3 save];
    
    Dynamic *dynamic4 = [[Dynamic alloc] init];
    dynamic4.isPraise = YES;
    dynamic4.location = @"北京市";
    dynamic4.createTime = @"前天 10:11";
    dynamic4.type = 1;
    dynamic4.text = @"夫君子之行，静以修身，俭以养德，非淡泊无以明志，非宁静无以致远";
    dynamic4.imageCount = 9;
    dynamic4.replyCount = 211;
    [dynamic4 save];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *data = [Dynamic findAll];
        dispatch_async(dispatch_get_main_queue(), ^{
            _dynamicData = [[NSMutableArray alloc] initWithArray:data];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dynamicData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicCell *cell = [DynamicCell cellWithTableView:tableView];
    Dynamic *dynamic = [_dynamicData objectAtIndex:indexPath.row];
    cell.dynamic = dynamic;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Dynamic *dynamic = [_dynamicData objectAtIndex:indexPath.row];
    return [DynamicCell heightOfCellWithModel:dynamic];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
