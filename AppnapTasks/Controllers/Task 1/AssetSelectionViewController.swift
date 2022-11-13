//
//  AssetSelectionViewController.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/11/22.
//

import UIKit
import AVKit

class AssetSelectionViewController: UIViewController,
                                    UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionViewParentView: UIView!
    
    lazy private var assetCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth-(40+20+30))/3, height: (screenWidth-(40+20+30))/3)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70), collectionViewLayout: layout)
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var selectedAssets : [AssetPickerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewParentView.addSubview(assetCollectionView)
        activityIndicator.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        assetCollectionView.frame = self.collectionViewParentView.bounds
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        let numberOfPhotos = selectedAssets.map{ $0.createdFromImage }.filter { $0 }.count
        let numberOfVideos = selectedAssets.count - numberOfPhotos
        
        if numberOfPhotos >= 2 && numberOfVideos >= 2{
            let mappedArray = selectedAssets.map{ $0.url }
            
            self.view.isUserInteractionEnabled = false
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            
            VideoMerging.merge(videos: mappedArray) { outputUrl in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let videoURL = outputUrl
                    let player = AVPlayer(url: videoURL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Please select atleast 2 images and 2 videos", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
            
        }
        

    }
    
    @IBAction func addAssetButtonAction(_ sender: Any) {
        
        openGallery()
        
    }
    
    
    
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
            if mediaType  == "public.image" {
                print("Image Selected")
                
                
                
                if let pickedImage = info[.originalImage] as? UIImage {
                    
                    DispatchQueue.main.async {
                        ImageToVideo.getVideo(for: pickedImage, durationInSeconds: 3) { outputVideoUrl in
                            
                            DispatchQueue.main.async {
                                /*let videoURL = outputVideoUrl
                                 let player = AVPlayer(url: videoURL)
                                 let playerViewController = AVPlayerViewController()
                                 playerViewController.player = player
                                 self.present(playerViewController, animated: true) {
                                 playerViewController.player!.play()*/
                                guard let thumbnail = outputVideoUrl.generateThumbnail() else {return}
                                self.selectedAssets.append(AssetPickerModel(url: outputVideoUrl, thumbnailImage: thumbnail, createdFromImage: true, selectionIndex: self.selectedAssets.count))
                                self.assetCollectionView.reloadData()
                                
                            }
                        }
                    }
                }
            }
            else{
                print("Video Selected")
                guard let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL, let thumbnail = mediaURL.generateThumbnail() else { return }
                selectedAssets.append(AssetPickerModel(url: mediaURL, thumbnailImage: thumbnail, createdFromImage: false, selectionIndex: selectedAssets.count))
                assetCollectionView.reloadData()
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}


extension AssetSelectionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        for view in cell.subviews{
            view.removeFromSuperview()
        }
        
        let imageView = UIImageView()
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: (screenWidth-(40+20+30))/3, height: (screenWidth-(40+20+30))/3))
        imageView.image = selectedAssets[indexPath.row].thumbnailImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        cell.addSubview(imageView)
        
        return cell
    }
    
    
    
    
}
