//
//  DemoSource.swift
//  MMPlayerView
//
//  Created by Millman YANG on 2017/8/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

struct DataObj {
    var image: URL?
    var play_Url: URL?
    var title = ""
}

class DemoSource: NSObject {
    
    var demoData = [DataObj]()
    
    
    override init() {
        demoData = [DataObj(image: URL(string: "https://lumiere-a.akamaihd.net/v1/images/image_659514fa.jpeg"),
                    play_Url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
                    title: "Ultralight Beam")
            
        ]
    }
}
