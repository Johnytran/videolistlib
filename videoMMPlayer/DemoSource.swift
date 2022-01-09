//
//  DemoSource.swift
//  MMPlayerView
//
//  Created by Millman YANG on 2017/8/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

struct DataObj {
    var image: UIImage?
    var play_Url: URL?
    var title = ""
}

class DemoSource: NSObject {
    
    var demoData = [DataObj]()
    
    
    override init() {
        demoData = [
            DataObj(image: UIImage(named: "two"),
                    play_Url: URL(string: "http://www.exit109.com/~dnn/clips/RW20seconds_1.mp4")!,
                    title: "Vertical Video"),
            
            DataObj(image: UIImage(named: "three"),
                    play_Url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
                    title: "Ultralight Beam"),
            
            DataObj(image: UIImage(named: "six"),
                    play_Url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!,
                    title: "You Want It Darker"),
            
            DataObj(image: UIImage(named: "ten"),
                    play_Url: URL(string: "https://bitmovin-a.akamaihd.net/content/playhouse-vr/m3u8s/105560.m3u8")!,
                    title: "What It Means"),
            
            DataObj(image: UIImage(named: "one"),
                    play_Url: URL(string: "http://yt-dash-mse-test.commondatastorage.googleapis.com/media/car-20120827-85.mp4")!,
                    title: "Black Beatles"),
            
            DataObj(image: UIImage(named: "two"),
                    play_Url: URL(string: "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4")!,
                    title: "Cranes In The Sky"),
            
            DataObj(image: UIImage(named: "seven"),
                    play_Url: URL(string: "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")!,
                    title: "Old Friends")
            
        ]
    }
}
