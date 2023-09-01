# RoundApp

## Requirements and thought process

This is what I thought would be a minimum viable product for the given requirements.
It currently only supports the primary account and only shows transactions in GBP. 
It shows the transactions in a list for the last 7 days and the round up balance of those transactions at the top.
Tapping on the add to Savings Goal button navigates the user to a Savings Goal screen. 
Again I followed an MVP kind of approach where, if the user doesn't have a savings goal, they can create one - and this functionality is currently hardcoded, meaning that the user does not have to enter any details but a Round Up goal is created for them. 
At the same time, if the user does have goals, I am only showing the first one for sake of simplicity, where they can add the round up amount. 
In a real world scenario, I would have displayed all saving goals and let them decide in which one to add their round up amount. 
Additionally, I made it impossible for the user to add the same round up amount multiple times on the same goal when on the Saving Goals screen.
The current implementation does not prevent the user from going back to the Transactions screen and adding the same round up amount again, but I thought it was a good enough compromise for now to keep the solution simple. 

## Architecture and technologies used

I went with iOS 13 as minimum deployment target. 
I remember being told that iOS 10 or 12 is still being used at Starling but I couldn't choose a lower deployment target in Xcode. 
Given that I'm most familiar with the MVVM architecture in conjunction with some lightweight use of RxSwift, I decided to go with that. 
I used a simplistic Coordinator pattern to handle navigation between screens. I appreciate it's not a scalable solution, but I thought it was a good enough compromise for this exercise. 
In a bigger app, each scene pair would have its own coordinator and some sort of navigation system would be in place to handle the navigation between scenes.
For the UI I went with programmatic interfaces using SnapKit for constraints. 
I used Cocoapods for dependency management, mainly to handle RxSwift and SnapKit. 
The network layer was written using URLSession and the Codable protocol. I decided to give a go at using async await for the network calls as it's one of those new Swift features that I've been wanting to try out. 
As for testing, I wrote unit tests mainly to check the business logic in the viewmodels adn also to cover the logic in some extensions I wrote.
Given more time, I would have added some snapshot tests for the UI as well.

## How to run

To run the app, clone the repo and run `pod install` in the root folder. 
Then open the `RoundApp.xcworkspace` file, go to `Config` folder and open the `Secrets.swift` file. 
Replace "ACCESS_TOKEN" with your own access token, making sure that the test account has at least one transaction.
Run the app on a simulator or device.


Thank you for taking the time to review my code!
