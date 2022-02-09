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
import CoreData


class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        l.repeatWhenEnd = true
        return l
    }()
    var dataSource = [DataObj]()
    
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var playerCollect: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        makeFloatMenu()
        getLocalData()
        //deleteAllData("Videos")
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getLocalData(){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Videos")
                request.returnsObjectsAsFaults = false
                
                let result = (try? managedContext.fetch(request)) ?? []
                for data in result as! [NSManagedObject] {
                    
                    //let title = (data.value(forKey: "title") as! String)
                    let videourl = (data.value(forKey: "src") as! String)
//                    let imageurl = (data.value(forKey: "image") as! String)
                    
//                        dataSource += [DataObj(image: imageurl,
//                                               play_Url: videourl,
//                                               title: title)
//
//                        ]
                       print(videourl)
                }
                    
                
        print(dataSource)
    }
    
    func deleteAllData(_ entity:String) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func saveVideo(obj: DataObj) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
        
      let entity =
        NSEntityDescription.entity(forEntityName: "Videos",
                                   in: managedContext)!
        let videoList = NSManagedObject(entity: entity, insertInto: managedContext)
      videoList.setValue(obj.title, forKeyPath: "videotitle")
      videoList.setValue(obj.image, forKeyPath: "image")
      videoList.setValue(obj.play_Url, forKeyPath: "src")
      
      appDelegate.saveContext()
      
    }
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let url = info[.mediaURL] as? URL else {
            imagePickerController.dismiss(animated: true, completion: nil)
            return;
        }
        
        
        
//        let demoData = DataObj(image: url.absoluteString,
//                               play_Url: url.absoluteString,
//                                title: "SRT File demo, detail show the text timeinterval")
//        saveVideo(obj: demoData)
//        playerCollect.reloadData()
        imagePickerController.dismiss(animated: true, completion: {
            self.showAddForm(url: url)
        })
    }
    
    func showAddForm(url: URL){
        if let addVideoView = Bundle.main.loadNibNamed("InfoVideo", owner: self, options: nil){
            let formView = addVideoView.first as! InfoVideo
            formView.frame = self.view.bounds
            formView.getParent(parent: self);
            UIView.transition(
                with: self.view,
                duration: 0.5,
                options: [.curveEaseOut, .transitionFlipFromBottom],
                animations: {
                    self.view.addSubview(formView)
                })
            
            formView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                formView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 10),
                formView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -10),
                formView.topAnchor.constraint(equalTo: view.topAnchor , constant: 100),
                formView.heightAnchor.constraint(equalToConstant: 633)
               ])
        }
    }
    func makeFloatMenu(){
        // set up floating button
        let actionButton = JJFloatingActionButton()
        
        actionButton.overlayView.backgroundColor = UIColor(hue: 0.31, saturation: 0.37, brightness: 0.10, alpha: 0.30)
        actionButton.buttonColor = .red
        
        actionButton.layer.shadowColor = UIColor.black.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        actionButton.layer.shadowOpacity = Float(0.4)
        actionButton.layer.shadowRadius = CGFloat(2)
        
        actionButton.itemAnimationConfiguration = .circularSlideIn(withRadius: 120)
        actionButton.buttonAnimationConfiguration = .rotation(toAngle: .pi * 3 / 4)
        actionButton.buttonAnimationConfiguration.opening.duration = 0.8
        actionButton.buttonAnimationConfiguration.closing.duration = 0.6
        
        actionButton.layer.shadowColor = UIColor.black.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        actionButton.layer.shadowOpacity = Float(0.4)
        actionButton.layer.shadowRadius = CGFloat(2)
        
        let libraryItem = actionButton.addItem()
        libraryItem.titleLabel.text = "Library"
        libraryItem.imageView.image = UIImage(named: "library")
        libraryItem.buttonColor = .clear
        libraryItem.imageSize = CGSize(width: 30, height: 30)
        libraryItem.action = { item in
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.delegate = self
            self.imagePickerController.mediaTypes = ["public.movie"]

            self.present(self.imagePickerController, animated: true, completion: nil)
        }

        let yotubeItem = actionButton.addItem()
        yotubeItem.titleLabel.text = "Youtube"
        yotubeItem.imageView.image = UIImage(named: "youtube")
        yotubeItem.buttonColor = .clear
        yotubeItem.imageSize = CGSize(width: 100, height: 50)
        yotubeItem.action = { item in
            
        }

        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        // end floating
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
//        if self.presentedViewController != nil || self.mmPlayerLayer.isShrink == true {
//                self.playerCollect.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//                self.updateDetail(at: indexPath)
//            } else {
//                self.presentDetail(at: indexPath)
//            }
        }
    }
    

    fileprivate func updateDetail(at indexPath: IndexPath) {
        let value = dataSource[indexPath.row]
        self.mmPlayerLayer.thumbImageView.downloaded(from: value.image!)
        self.mmPlayerLayer.set(url: URL(string: dataSource[indexPath.row].play_Url!))
        self.mmPlayerLayer.resume()
        
    }
    
    fileprivate func presentDetail(at indexPath: IndexPath) {
        self.updateCell(at: indexPath)
        mmPlayerLayer.resume()
    }
    
    fileprivate func updateCell(at indexPath: IndexPath) {
        if let cell = playerCollect.cellForItem(at: indexPath) as? PlayerCell, let playURL = cell.data?.play_Url {
            // this thumb use when transition start and your video dosent start
            mmPlayerLayer.thumbImageView.image = cell.imgView.image
            // set video where to play
            mmPlayerLayer.playView = cell.imgView
            mmPlayerLayer.set(url: URL(string: playURL))
        }
    }
    
    @objc fileprivate func startLoading() {
        //self.updateByContentOffset()
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
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
            cell.data = dataSource[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}


