//
//  Utils.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/11/22.
//

import Foundation
import AVKit

let screenWidth : CGFloat = UIScreen.main.bounds.width
let screenHeight : CGFloat = UIScreen.main.bounds.height

extension URL{
    func generateThumbnail() -> UIImage? {
        do {
            let asset = AVURLAsset(url: self, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}


extension CGSize {
    
    static func aspectFit(videoSize: CGSize, boundingSize: CGSize) -> CGSize {
        
        
      
        
        var size = boundingSize
        let mW = boundingSize.width / videoSize.width;
        let mH = boundingSize.height / videoSize.height;
        
        if( mH < mW ) {
            size.width = boundingSize.height / videoSize.height * videoSize.width;
        }
        else if( mW < mH ) {
            size.height = boundingSize.width / videoSize.width * videoSize.height;
        }
        
      
        
        
        return size;
    }
    
    static func aspectFill(videoSize: CGSize, boundingSize: CGSize) -> CGSize {
        
        var size = boundingSize
        let mW = boundingSize.width / videoSize.width;
        let mH = boundingSize.height / videoSize.height;
        
        if( mH > mW ) {
            size.width = boundingSize.height / videoSize.height * videoSize.width;
        }
        else if ( mW > mH ) {
            size.height = boundingSize.width / videoSize.width * videoSize.height;
        }
        
        return size;
    }
    
    
    func ratio(ratio:CGFloat)->CGSize{
        if ratio > 1{
            // landScape image
            if isLandScape{
                return  CGSize(width: self.width, height: self.width / ratio)
            }else{
                return  CGSize(width: self.height, height: self.height / ratio)
            }
            
            
            
        }else{
            // portrait image
            if isLandScape{
                return  CGSize(width: self.width * ratio, height: self.width)
            }else{
                return  CGSize(width: self.height * ratio, height: self.height)
            }
        }
    }
    
    
    
    func ratioMin(ratio:CGFloat)->CGSize{

        if ratio >= 1{
            // landScape image
            if !isLandScape{
                print("L->P : \(CGSize(width: self.width, height: self.width / ratio))")
                return  CGSize(width: self.width, height: self.width / ratio)
            }else{
                print("L->L : \(CGSize(width: self.height, height: self.height / ratio))")
                return  CGSize(width: self.height, height: self.height / ratio)
            }



        }else{
            // portrait image

            if isLandScape{
                print("P->L : \(CGSize(width: self.width * ratio, height: self.width))")
                return  CGSize(width: self.width * ratio, height: self.width)
            }else{
                print("P->P : \(CGSize(width: self.height * ratio, height: self.height))")
                return  CGSize(width: self.height * ratio, height: self.height)
            }
        }
    }
    
    
    func ratioMin2(ratio:CGFloat)->CGSize{
        
        if self.height > self.width{//PR-VID
            if(ratio > 1) {return CGSize(width: self.height*ratio, height: self.height)}
            else if (ratio == 1){ return CGSize(width: self.height, height: self.height)}
            else{ return CGSize(width: self.width, height: self.width*(1/ratio))}
        }else{//LN-VID+SQ-VID
            if(ratio > 1) {return CGSize(width: self.height*ratio, height: self.height)}
            else if (ratio == 1){ return CGSize(width: self.width, height: self.width)}
            else{ return CGSize(width: self.width, height: self.width*(1/ratio))}
        }
        
    }
    
    
    var isLandScape:Bool{
     return self.width > self.height
    }
    
}

