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
    
    self.title = @"Greek Gods";
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://greek-gods.firebaseio.com/"];
    
    // get and store data from database.
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
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
    NSString *key = self.keys[indexPath.row];
    cell.textLabel.text = [[self.data valueForKey:key] valueForKey:@"name"];
    cell.detailTextLabel.text = @"";
    
    
    return cell;
}


#pragma mark - Navigation

- (IBAction)toTableVC:(UIStoryboardSegue *)sender
{
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // get index of selected row
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"Detail View"]) {
            if ([segue.destinationViewController isKindOfClass:[GreekGodDetailVC class]]) {
                GreekGodDetailVC *gvc = segue.destinationViewController;
                NSString *key = self.keys[indexPath.row];
                gvc.godData = [self.data valueForKey: key];
                gvc.name = [gvc.godData valueForKey:@"name"];
                gvc.key = key;
            }
        }
    }
}


@end
