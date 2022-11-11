//
//  String+Extension.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/11/22.
//

import Foundation
import UIKit

extension String{
    func getRandomName(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
