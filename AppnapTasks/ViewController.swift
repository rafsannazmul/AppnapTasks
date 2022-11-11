//
//  ViewController.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/11/22.
//

import UIKit
import AVKit

class ViewController: UIViewController,
                      UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                                let videoURL = outputVideoUrl
                                let player = AVPlayer(url: videoURL)
                                let playerViewController = AVPlayerViewController()
                                playerViewController.player = player
                                self.present(playerViewController, animated: true) {
                                    playerViewController.player!.play()
                                }
                            }
                        }
                    }
                }
            }

            if mediaType == "public.movie" {
                print("Video Selected")
                
            }
        }
        
        //guard let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        picker.dismiss(animated: true, completion: nil)
    }



}

