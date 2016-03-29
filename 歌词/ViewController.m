//
//  ViewController.m
//  歌词
//
//  Created by myApple on 16/3/15.
//  Copyright © 2016年 myApple. All rights reserved.
//

#import "ViewController.h"
#import "LrcParser.h"

@interface ViewController ()
- (IBAction)btnPlay:(id)sender;
- (IBAction)sliderBar:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *sliderBar;
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger currentRow;
@property(strong,nonatomic)LrcParser *licContent;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableV.dataSource=self;
    self.licContent=[[LrcParser alloc]init];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initPlayer{
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"朴树-平凡之路" withExtension:@"mp3"];
    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [self.licContent parseGetLrc:@"朴树-平凡之路"];
    [self.tableV reloadData];
    [NSTimer scheduledTimerWithTimeInterval:0.5  target:self selector:@selector(updateTime) userInfo:nil repeats:YES];

    [self.player prepareToPlay];
    [self.player play];
    self.sliderBar.minimumValue=0;
    self.sliderBar.maximumValue=self.player.duration;
   
    NSLog(@"%@",self.licContent.timerArray);
}

-(void)updateTime {
    CGFloat currentTime=self.player.currentTime;
//    NSLog(@"%d:%d",(int)currentTime/60,(int)currentTime%60);
    for (int i=0; i<self.licContent.timerArray.count; i++) {
        NSArray *timeArray=[self.licContent.timerArray[i] componentsSeparatedByString:@":"];
        float  lrcTime=[timeArray[0] intValue]*60+[timeArray[1] floatValue];
        if (currentTime>lrcTime) {
            _currentRow=i;
        }
        else
        {
            break;
        }
    }
    [self.tableV reloadData];
    [self.tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (IBAction)btnPlay:(id)sender {
    [self initPlayer];
    

}

- (IBAction)sliderBar:(id)sender {
    UISlider *slider=(UISlider *)sender;
    self.player.currentTime=slider.value;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.licContent.wordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    cell.textLabel.text=self.licContent.wordArray[indexPath.row];
    if (indexPath.row==_currentRow) {
        cell.textLabel.textColor=[UIColor redColor];
    }
    else
    {
        cell.textLabel.textColor=[UIColor purpleColor];
    }
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

@end
