//
//  FilterSelectionViewController.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/11/22.
//

import UIKit
import AVKit

class FilterSelectionViewController: UIViewController {
    
    var videoURLs : [URL] = []
    var selectedTransitionIndex : Int = 0
    var selectedFitlerIndex : Int = 0
    
    @IBOutlet weak var filter1Button: UIButton!
    @IBOutlet weak var filter2Button: UIButton!
    @IBOutlet weak var filter3Button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        VideoMerging.merge(videos: videoURLs, transitionIndex: selectedTransitionIndex, filterIndex: selectedFitlerIndex) { outputUrl in
            DispatchQueue.main.async {
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
    
    @IBAction func filter1ButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func filter2ButtonAction(_ sender: Any) {
    }
    
    @IBAction func filter3ButtonAction(_ sender: Any) {
    }
    
}
