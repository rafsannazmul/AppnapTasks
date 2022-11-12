//
//  TransitionSelectionViewController.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/11/22.
//

import UIKit
import AVKit

class TransitionSelectionViewController: UIViewController {
    
    @IBOutlet weak var collectionViewParentView: UIView!
    
    
    @IBOutlet weak var transition1Button: UIButton!
    
    @IBOutlet weak var transition2Button: UIButton!
    
    @IBOutlet weak var transition3Button: UIButton!
    
    
    var videoURLs : [URL] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func transition1ButtonAction(_ sender: Any) {
        setSelection(index: 0)
        gotoFilterVC(transitionSelected: 0)
    }
    
    @IBAction func transition2ButtonAction(_ sender: Any) {
        setSelection(index: 1)
        gotoFilterVC(transitionSelected: 1)
    }
    
    @IBAction func transition3ButtonAction(_ sender: Any) {
        setSelection(index: 2)
        gotoFilterVC(transitionSelected: 2)
    }
    
    func gotoFilterVC(transitionSelected: Int){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterSelectionViewController") as! FilterSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.videoURLs = self.videoURLs
        vc.selectedTransitionIndex = transitionSelected
        self.present(vc, animated: true)
    }
    
    func setSelection(index: Int){
        for (idx,value) in [transition1Button,transition2Button,transition3Button].enumerated(){
            if idx == index{
                value?.backgroundColor = .tintColor
            }
            else{
                value?.backgroundColor = .darkGray
            }
        }
    }
    
}
