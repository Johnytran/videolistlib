//
//  ViewController.swift
//  videoMMPlayer
//
//  Created by Owner on 1/1/22.
//

import UIKit
import MMPlayerView
import AVFoundation
import JJFloatingActionButton

class ViewController: UIViewController {

    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        l.repeatWhenEnd = true
        return l
    }()
    var demoSource = DemoSource()
    var demoData = [DataObj]();
    
    @IBOutlet weak var playerCollect: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        demoData = [
            DataObj(image: UIImage(named: "one"),
                    play_Url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
                    title: "SRT File demo, detail show the text timeinterval")]
        demoData += demoSource.demoData;
        
        
        let actionButton = JJFloatingActionButton()

        actionButton.addItem(title: "item 1", image: UIImage(named: "First")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
        }

        actionButton.addItem(title: "item 2", image: UIImage(named: "Second")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
        }

        actionButton.addItem(title: "item 3", image: nil) { item in
          // do something
        }

        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    

}

// This protocol use to pass playerLayer to second UIViewcontroller
extension ViewController: MMPlayerFromProtocol {
    // when second controller pop or dismiss, this help to put player back to where you want
    // original was player last view ex. it will be nil because of this view on reuse view
    func backReplaceSuperView(original: UIView?) -> UIView? {
        guard let path = self.findCurrentPath() else {
            return original
        }
        
        let cell = self.findCurrentCell(path: path) as! PlayerCell
        return cell.imgView
    }

    // add layer to temp view and pass to another controller
    var passPlayer: MMPlayerLayer {
        return self.mmPlayerLayer
    }
    func transitionWillStart() {
    }
    // show cell.image
    func transitionCompleted() {
        self.updateByContentOffset()
        self.startLoading()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let m = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        return CGSize(width: m, height: m*0.75)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       DispatchQueue.main.async { [unowned self] in
        if self.presentedViewController != nil || self.mmPlayerLayer.isShrink == true {
                self.playerCollect.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                self.updateDetail(at: indexPath)
            } else {
                self.presentDetail(at: indexPath)
            }
        }
    }
    
    fileprivate func updateByContentOffset() {
        if mmPlayerLayer.isShrink {
            return
        }
        
        if let path = findCurrentPath(),
            self.presentedViewController == nil {
            self.updateCell(at: path)
            //Demo SubTitle
            if path.row == 0, self.mmPlayerLayer.subtitleSetting.subtitleType == nil {
                let subtitleStr = Bundle.main.path(forResource: "srtDemo", ofType: "srt")!
                if let str = try? String.init(contentsOfFile: subtitleStr) {
                    self.mmPlayerLayer.subtitleSetting.subtitleType = .srt(info: str)
                    self.mmPlayerLayer.subtitleSetting.defaultTextColor = .red
                    self.mmPlayerLayer.subtitleSetting.defaultFont = UIFont.boldSystemFont(ofSize: 20)
                }
            }
        }
    }

    fileprivate func updateDetail(at indexPath: IndexPath) {
        let value = demoData[indexPath.row]
//        if let detail = self.presentedViewController as? DetailViewController {
//            detail.data = value
//        }
        
        self.mmPlayerLayer.thumbImageView.image = value.image
        self.mmPlayerLayer.set(url: demoData[indexPath.row].play_Url)
        self.mmPlayerLayer.resume()
        
    }
    
    fileprivate func presentDetail(at indexPath: IndexPath) {
        self.updateCell(at: indexPath)
        mmPlayerLayer.resume()

//        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
//            vc.data = DemoSource.shared.demoData[indexPath.row]
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    fileprivate func updateCell(at indexPath: IndexPath) {
        if let cell = playerCollect.cellForItem(at: indexPath) as? PlayerCell, let playURL = cell.data?.play_Url {
            // this thumb use when transition start and your video dosent start
            mmPlayerLayer.thumbImageView.image = cell.imgView.image
            // set video where to play
            mmPlayerLayer.playView = cell.imgView
            mmPlayerLayer.set(url: playURL)
        }
    }
    
    @objc fileprivate func startLoading() {
        self.updateByContentOffset()
        if self.presentedViewController != nil {
            return
        }
        // start loading video
        mmPlayerLayer.resume()
    }
    
    private func findCurrentPath() -> IndexPath? {
        let p = CGPoint(x: playerCollect.frame.width/2, y: playerCollect.contentOffset.y + playerCollect.frame.width/2)
        return playerCollect.indexPathForItem(at: p)
    }
    
    private func findCurrentCell(path: IndexPath) -> UICollectionViewCell {
        return playerCollect.cellForItem(at: path)!
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return demoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
            cell.data = demoData[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}
