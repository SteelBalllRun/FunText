//
//  ViewController.m
//  FunText
//
//  Created by evans on 01/12/2016.
//  Copyright © 2016 evans. All rights reserved.
//

#import "ViewController.h"
#import "SFFunText.h"

@interface ViewController ()
@property (nonatomic, strong) SFFunText * text;
@property (nonatomic, strong) NSArray * nameList;
@end

@implementation ViewController

static int nameIndex = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameList = @[@"君の名は。",@"你的名字。", @"YourName."];
    // Do any additional setup after loading the view, typically from a nib.
    self.text = [[SFFunText alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.text.text = @"君の名は。";
    self.text.font = [UIFont fontWithName:@"Kozuka Mincho Pr6N" size:28];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self.text setCenter:CGPointMake(screenSize.width/2, 100)];
    [self.view addSubview:self.text];
    
}

- (void)transform
{
    static int timer = 0;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSString *time = [formatter stringFromDate:date];
    self.text.text = [NSString stringWithFormat:@"%@",time];
    timer ++;
    
    if (timer > 3) {
        [self.text vanish:nil];
    }else
    {
        [self.text startPlay];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (timer > 3) {
            
        }else
        {
            timer += 1;
            [self transform];
        }
        
        
    });
}

- (IBAction)changeLabel:(id)sender {
//    [self transform];
    nameIndex += 1;
    self.text.text = [self.nameList objectAtIndex:nameIndex%self.nameList.count];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
