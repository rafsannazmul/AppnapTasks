//
//  CustomCVViewController.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/13/22.
//
import UIKit

class CustomCVViewController: UIViewController {
    
    
    enum CustomCluster{
        case smallBox
        case mediumBox
        case largeBox
    }
    
    
    lazy private var customCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
        layout.itemSize = CGSize(width: screenWidth - 40, height: 100)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70), collectionViewLayout: layout)
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .systemTeal
        collectionView.isUserInteractionEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("---------> \(IntegerChecker.isValidArraySum(inputArray: k_GIVEN_ARRAY, maximumSum: k_MAXIMUM_SUM))")
        print("--------->> \(IntegerChecker.isArrayValid(input: k_GIVEN_ARRAY))")
        
        
        self.customCollectionView.frame = self.view.frame
        self.view.addSubview(customCollectionView)
        
    }

    var transformationArray : [CustomCluster] = []

}



extension CustomCVViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, sizeForViewAtIndexPath indexPath: IndexPath) -> Int {
        if(indexPath.row == 0 || indexPath.row == 4)
        {
            return 2
        }

        if(indexPath.row == 5)
        {
            return 3
        }

        return 1
    }
    
    func numberOfColumnsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return k_GIVEN_ARRAY.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if k_GIVEN_ARRAY[indexPath.row] == 1{
            cell.backgroundColor = #colorLiteral(red: 0.01137481444, green: 0.9990260005, blue: 0.1636038423, alpha: 1)
        }
        else if k_GIVEN_ARRAY[indexPath.row] == 4{
            cell.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        else{
            cell.backgroundColor = #colorLiteral(red: 0.01110379305, green: 0.9990332723, blue: 0.9398687482, alpha: 1)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if k_GIVEN_ARRAY[indexPath.row] == 1{
            return CGSize(width: (collectionView.frame.width/4) - (20*3), height: (collectionView.frame.width/4) - (20*3))
        }
        
        else if k_GIVEN_ARRAY[indexPath.row] == 4{
            return CGSize(width: (collectionView.frame.width/2) - (20*1), height: (collectionView.frame.width/2) - (20*1))
        }
        else{
            return CGSize(width: collectionView.frame.width - 40, height: (collectionView.frame.width/2) - (20*1))
        }
    }
    
}

