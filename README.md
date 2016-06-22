#IGT Developer Task Design Considerations and Walkthrough

I used an MVVM architecture in order to separate the concern of presenting the view rather than placing all the business logic into the view controller making the MVC a massive view controller. 

The models are preferably created as structures with value type semantics. However the MasterList model needed to be an NSObject because I used KVO to bind asynchronous changes from the view model to the view controller. An alternative to KVO is NSNotification, however this has global scope and breaks local reasoning. If allowed, I would have used RxSwift to observe state changes since it's more elegant with less boiler plate code, but a requirement not to use third party libraries is enforced.

I also used local notification to schedule expiration. NSTimer, Global Central Dispatch (GCD) and NSOperationQueue will cancel expiration if app is manually killed. This way with local notification, the user is prompted even when the app is not running. Model views should not import UIKit, however MastersViewModel need to schedule local notifications which requires UIKit. To solve this problem, I used delegation pattern to delegate this responsibility to the owning view controller. The view model however controls all the parameter supplied to the notification. NSNotification is used to to inform the model view from the AppDelegate callback on the arrival of the local notification payload. Maybe there's a more elegant solution than this since I tried to parse the navigation controller tree to get a reference of the view model from the AppDelegate but it looked very hacky and ugly since the tree includes state changes of the navigation stack. NSNotification has the global scope needed to solve this problem.

I used NSURLSession with an Alamofire inspired Router making URL composition more flexible and easier to maintain. I also used NSJSONSerialization to transform the data into dictionary and eventually parsing into first class Swift models (structs or classes). I used NSFileManager to save the data. Instead of saving the data into a text file, the NSData is written into file straight from the URL response. Extra processing of saving the data into a text file without a clear purpose is not necessary. I used NSNumberFormatter with the given currency code to format the jackpot. On the other hand I used NSDateFormatter to localise the formatted date. All formatting are done in the view model layer. I used XCTestExpectation to asynchronously test the fetched data from the URL. Testing for localisation was tricky. Since iOS 8.2 and above, programatically changing the language is not applied unless the device is rebooted. I used Swift pattern matching to distinguish iOS versions in testing.

End
