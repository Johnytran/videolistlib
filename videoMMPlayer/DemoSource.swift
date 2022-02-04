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
                    play_Url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                    title: "Ultralight Beam")
            
        ]
    }
}
