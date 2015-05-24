#import "RecognitionViewController.h"
#import "AppDelegate.h"

//#error Provide Application ID and Password
// To create an application and obtain a password,
// register at http://cloud.ocrsdk.com/Account/Register
// More info on getting your application id and password at
// http://ocrsdk.com/documentation/faq/#faq3

// Name of application you created
static NSString* MyApplicationID = @"testHack";
// Password should be sent to your e-mail after application was created
static NSString* MyPassword = @"fzs1XmPvy+p50vRP6lIiNAAb";

@implementation RecognitionViewController

{
    NSArray *tableData;
}

@synthesize textView;
@synthesize statusLabel;
@synthesize statusIndicator;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * mainIdeas = @"Chile"; //This will be data from main concepts from our text search/index from the OCR data. Currently I'm setting it to Chile just to test
    NSString * sFeedURL = [NSString stringWithFormat:@"http://dragonflysearch.com/api/search.php?q=%@", mainIdeas];
    //RSS Feed URL goes between quotes
    [super viewDidLoad];
    
    // Initialize table data
    tableData = [NSArray arrayWithObjects:@"Steve Jobs", @"Bill Gates", @"Elon Musk", @"Peter Thiel", @"Big Head", @"Erlcih Bachman", @"Richard Hendrix", @"Gillzean", @"Dinesh", @"Gavin Hooli", nil];
    
    NSString * sActualFeed = [NSString stringWithContentsOfURL:[NSURL URLWithString:sFeedURL] encoding:1 error:nil];
    
    
    //    lblOne.text = sActualFeed;
    NSLog(@"%@", sActualFeed);
    
    // NSString * sActualFeed = _summary.text;
    //  [NSString sActualFeed componentsSeparatedByString:@","]
    //  [NSString sActualFeed:@"",""];
    
    _summary.text = [NSString stringWithFormat:@"%@",sActualFeed]; //Hook up the actual text field with what's going on in here
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
	[self setTextView:nil];
	[self setStatusLabel:nil];
	[self setStatusIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	textView.hidden = YES;
	
	statusLabel.hidden = NO;
	statusIndicator. hidden = NO;
	
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	statusLabel.text = @"Loading image...";
	
	UIImage* image = [(AppDelegate*)[[UIApplication sharedApplication] delegate] imageToProcess];
	
	Client *client = [[Client alloc] initWithApplicationID:MyApplicationID password:MyPassword];
	[client setDelegate:self];
	
	if([[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"] == nil) {
		NSString* deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
		
		NSLog(@"First run: obtaining installation ID..");
		NSString* installationID = [client activateNewInstallation:deviceID];
		NSLog(@"Done. Installation ID is \"%@\"", installationID);
		
		[[NSUserDefaults standardUserDefaults] setValue:installationID forKey:@"installationID"];
	}
	
	NSString* installationID = [[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"];
	
	client.applicationID = [client.applicationID stringByAppendingString:installationID];
	
	ProcessingParams* params = [[ProcessingParams alloc] init];
	
	[client processImage:image withParams:params];
	
	statusLabel.text = @"Uploading image...";
	
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark - ClientDelegate implementation

- (void)clientDidFinishUpload:(Client *)sender
{
	statusLabel.text = @"Processing image...";
}

- (void)clientDidFinishProcessing:(Client *)sender
{
	statusLabel.text = @"Downloading result...";
}

- (void)client:(Client *)sender didFinishDownloadData:(NSData *)downloadedData
{
	statusLabel.hidden = YES;
	statusIndicator.hidden = YES;
	
	textView.hidden = NO;
	
	NSString* result = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
	
    textView.text = @"Steven Paul Steve Jobs (/ˈdʒɒbz/; February 24, 1955 – October 5, 2011) was an American entrepreneur, marketer, and inventor, who was the cofounder, chairman, and CEO of Apple Inc Through Apple, he was widely recognized as a charismatic and design-driven pioneer of the personal computer revolution and for his influential career in the computer and consumer electronics fields, transforming one industry after another, from computers and smartphones to music and movies. Jobs also funded what would become Pixar Animation Studios; he became a member of the board of directors of The Walt Disney Company in 2006, when Disney acquired Pixar."; //text result
}

- (void)client:(Client *)sender didFailedWithError:(NSError *)error
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:[error localizedDescription]
												   delegate:nil 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles:nil, nil];
	
	[alert show];
	
	statusLabel.text = [error localizedDescription];
	statusIndicator.hidden = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

@end
