//
//  Models.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/11/22.
//

import Foundation
import UIKit



struct AssetPickerModel {
    var url : URL
    var thumbnailImage : UIImage
    var createdFromImage : Bool
    var selectionIndex: Int
}


struct IntegerChecker {
    
    static func isArrayValid(input: [Int]) -> Bool{
        for i in input{
            if i != 1 && i != 4 && i != 8{
                return false
            }
        }
        return true
    }
    
    static func sum(input: [Int]) -> Int{
        return input.reduce(0, +)
    }
    
    static func isValidArraySum(inputArray: [Int], maximumSum: Int) -> Bool{
        return sum(input: inputArray) < maximumSum
    }
    
}
