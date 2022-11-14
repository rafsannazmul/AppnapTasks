//
//  ViewController.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/11/22.
//

import UIKit
import AVKit

class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func task1ButtonAction(_ sender: Any) {
        

        let task1VC = self.storyboard?.instantiateViewController(withIdentifier: "AssetSelectionViewController") as! AssetSelectionViewController
        task1VC.modalPresentationStyle = .overFullScreen
        self.present(task1VC, animated: true)
        
    }
    
    @IBAction func task2ButtonAction(_ sender: Any) {
        
        let task2VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomCVViewController") as! CustomCVViewController
        task2VC.modalPresentationStyle = .overFullScreen
        self.present(task2VC, animated: true)
        
    }



}

