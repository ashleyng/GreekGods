//
//  GreekGodDetailVC.m
//  Greek-Gods
//
//  Created by Ashley Ng on 6/1/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import "GreekGodDetailVC.h"
#import "FormVC.h"
#import <Firebase/Firebase.h>
#import "constants.h"

@interface GreekGodDetailVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *romanLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *repText;
@property (strong, nonatomic) IBOutlet UILabel *symbolsText;

@end

@implementation GreekGodDetailVC


/*
    format an array into a comma seperated string
 */
- (NSString *)formatArrayToString:(NSArray *)array
{
    NSMutableString *return_string = [[NSMutableString alloc] init];
    for (id value in array) {
        if ([value isKindOfClass:[NSString class]])
        {
            [return_string appendFormat:@"%@, ", (NSString *)value];
        }
    }
    return return_string;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Firebase *ref = [[Firebase alloc] initWithUrl: FIREBASE_URL];
# warning possible making multiple observers with every call to viewDidLoad?
    [ref observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        self.data = snapshot.value;
        [self reloadData];
    }];
    
    [self reloadData];
    
}

# warning need to fix vertical spacing within representation and symbols label
- (void)reloadData
{
    self.nameLabel.text = [self.data valueForKey:@"name"];
    self.romanLabel.text = [self.data valueForKey:@"roman"];
    self.repText.text = [self formatArrayToString:[self.data valueForKey:@"rep"]];
    self.symbolsText.text = [self formatArrayToString:[self.data valueForKey:@"symbol"]];
    if (![[self.data valueForKey:@"image"] isEqualToString:@""]) {
        self.image.image = [self decodeImage: [self.data valueForKey:@"image"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Edit Data"]) {
        if ([segue.destinationViewController isKindOfClass:[FormVC class]]) {
            FormVC *fvc = segue.destinationViewController;
            fvc.data = self.data;
            fvc.key = self.key;
            fvc.isEditForm = YES;
        }
    }
}

- (UIImage *)decodeImage:(NSString *)encodedImage {
    NSData *decodedData = [[NSData alloc]
                           initWithBase64EncodedString:encodedImage
                           options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:decodedData];
    return image;
}

- (IBAction)toDetailVC:(UIStoryboardSegue *)sender
{
    
}



@end
