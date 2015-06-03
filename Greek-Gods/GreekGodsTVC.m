//
//  GreekGodsTVC.m
//  Greek-Gods
//
//  Created by Ashley Ng on 6/1/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import "GreekGodsTVC.h"
#import <Firebase/Firebase.h>
#import "GreekGodDetailVC.h"

@interface GreekGodsTVC ()

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *keys;

@end

@implementation GreekGodsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Greek Gods";
    NSLog(@"Load View");
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://greek-gods.firebaseio.com/"];
    
    // get and store data from database
# warning makes database call everytime, even if nothing to update. Need to cache
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //        NSLog(@"%@", snapshot.value);
        self.data = snapshot.value;
        self.keys = [self.data allKeys];
        NSLog(@"Data successfully retieved and stored");
        [self.tableView reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Greek God Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.keys[indexPath.row];
    cell.detailTextLabel.text = @"";
    
    
    return cell;
}

- (IBAction)toTableVC:(UIStoryboardSegue *)sender
{
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // get index of selected row
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if (indexPath ) {
        if ([segue.identifier isEqualToString:@"Detail View"]) {
            NSLog(@"%@", [segue.destinationViewController class]);
            if ([segue.destinationViewController isKindOfClass:[GreekGodDetailVC class]]) {
                GreekGodDetailVC *gvc = segue.destinationViewController;
                gvc.godData = self.data[self.keys[indexPath.row]];
                gvc.name = self.keys[indexPath.row];
            }
        }
    }
}


@end
