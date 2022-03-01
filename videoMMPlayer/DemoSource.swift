//
//  DemoSource.swift
//  MMPlayerView
//
//  Created by Millman YANG on 2017/8/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

struct DataObj {
    var image: String?
    var play_Url: String?
    var title = ""
}

class DemoSource: NSObject {
    
    var demoData = [DataObj]()
    
    
    override init() {
        demoData = [DataObj(image: "https://lumiere-a.akamaihd.net/v1/images/image_659514fa.jpeg",
                    play_Url:  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                    title: "Ultralight Beam")
            
        ]
    }
}


//        dataSource += [DataObj(image: "file:///Users/owner/Library/Developer/CoreSimulator/Devices/36A14FA3-84CD-4BD2-A919-C5B9747D0172/data/Containers/Data/Application/151AF684-78B8-4C8C-B481-913356AE8CC1/Documents//009F7E1C-623A-41B0-BC0D-CF3E1D6596CF-44356-000180418C41063C.jpg", play_Url:"file:///Users/owner/Library/Developer/CoreSimulator/Devices/36A14FA3-84CD-4BD2-A919-C5B9747D0172/data/Containers/Data/Application/151AF684-78B8-4C8C-B481-913356AE8CC1/Documents/DE69BB43-4C71-4D7E-AB74-418089DE7C71-44356-0001803FD4B86D01.mp4", title: "disaffected")]
//print(dataSource)


//demo 3
//        dataSource = [DataObj(image: "https://lumiere-a.akamaihd.net/v1/images/image_659514fa.jpeg",
//                    play_Url:  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
//                    title: "Ultralight Beam")]
