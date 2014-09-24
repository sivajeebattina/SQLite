//
//  StudentDetailsTableViewController.m
//  SQLite
//
//  Created by pcs20 on 9/22/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import "StudentDetailsTableViewController.h"
#import "AddStudentViewController.h"
#import "StudentDetailsViewController.h"

@interface StudentDetailsTableViewController (){

    NSMutableArray *studentObjectsArray;
   
}

@end

@implementation StudentDetailsTableViewController{

    NSString *identification;
    NSIndexPath *indexPathvariable;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self copyDatabaseBundleToDocument];
    [self updateData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return studentObjectsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentName"];
    
    Student *studentObject=[studentObjectsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=studentObject.studentName;
    cell.detailTextLabel.text=studentObject.studentID;
    
    
    // Configure the cell...
    
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    
    
    indexPathvariable=indexPath;

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        UIAlertView *deleteWarning=[[UIAlertView alloc] initWithTitle:@"Delete Warning!!" message:@"Are you sure want to delete data from database?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        
        
        [deleteWarning show];
        
        Student *tempObject=[studentObjectsArray objectAtIndex:indexPath.row];
        identification=tempObject.studentID;
        
        
       
        
        
        [self.tableView reloadData];
       
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }


}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"AddStudent"]) {
        
        AddStudentViewController *addStudent=[segue destinationViewController];
        addStudent.firstDelegate=self;
        
    }
    
    else if([[segue identifier] isEqualToString:@"gotoStudentDetails"]){
        
        
        StudentDetailsViewController *StudentDetails=[segue destinationViewController];
        StudentDetails.secondDelegate=self;
        NSIndexPath *selectedIndexpath=[self.tableView indexPathForSelectedRow];
        Student *student=[studentObjectsArray objectAtIndex:selectedIndexpath.row];
        
        StudentDetails.identification=student.studentID;

    
    }
}

/**** THIS is the code for creating database*****/

-(NSString *)getDBFileFromDocumentDirectory{
    
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbpath=[pathArray objectAtIndex:0];
    dbpath=[dbpath stringByAppendingPathComponent:@"StudentDB.sqlite"];
    
    return dbpath;
    
}
-(NSString *)getDBFileFromAppBundle{
    NSString *bundlePath=[[NSBundle mainBundle] bundlePath];
    bundlePath=[bundlePath stringByAppendingPathComponent:@"StudentDB.sqlite"];
   
    
    return bundlePath;
}
-(void)copyDatabaseBundleToDocument{
    
    NSString *bundlePath=[self getDBFileFromAppBundle];
    NSString *dbPath=[self getDBFileFromDocumentDirectory];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPath]) {
        BOOL isSuccess=[fileManager copyItemAtPath:bundlePath toPath:dbPath error:nil];
        
        if (isSuccess) {
            NSLog(@"SQLite Database created Succesfully");
        }
        else{
            NSLog(@"Database failed to create");
        }
    }
    
}


-(void)updateData{
    
    studentObjectsArray=[[NSMutableArray alloc] init];
    
    NSString *dbFilePath =[self getDBFileFromDocumentDirectory];
    const char *dbUtfString = [dbFilePath UTF8String];
    if (sqlite3_open(dbUtfString, &database)==SQLITE_OK)
    {
        NSString *selectQuery = [NSString stringWithFormat:@"Select * from  Student"];
        const char *queryUtf8 = [selectQuery UTF8String];
        sqlite3_stmt *statment;
        if (sqlite3_prepare(database, queryUtf8, -1, &statment, NULL)==SQLITE_OK )
        {
            
            
            while (sqlite3_step(statment)==SQLITE_ROW)
            {
                Student *studentOBj = [[Student alloc] init];
                studentOBj.studentName =[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statment, 0)];
                studentOBj.studentID= [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 1)];
                
                [studentObjectsArray addObject:studentOBj];
                
            }
            
            [self.tableView reloadData];
            
            
        }
        sqlite3_finalize(statment);
    }
    sqlite3_close(database);
    
    
    
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        [studentObjectsArray removeObjectAtIndex:indexPathvariable.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathvariable] withRowAnimation:UITableViewRowAnimationFade];
        
        NSString *dbFilePath =[self getDBFileFromDocumentDirectory];
        const char *dbUtfString = [dbFilePath UTF8String];
        if (sqlite3_open(dbUtfString, &database)==SQLITE_OK)
        {
            NSString *selectQuery = [NSString stringWithFormat:@"delete from  Student where StudentID='%@'",identification];
            const char *queryUtf8 = [selectQuery UTF8String];
            sqlite3_stmt *statment;
            if (sqlite3_prepare(database, queryUtf8, -1, &statment, NULL)==SQLITE_OK )
            {
                
                
                if(sqlite3_step(statment)==SQLITE_ROW)
                {
                    NSLog(@"Deleted Successfully");
                    
                }
                
                [self.tableView reloadData];
                
                
            }
            sqlite3_finalize(statment);
        }
        sqlite3_close(database);
        

        
        
    }
   
}



@end
