//
//  UIImageToVideo.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/11/22.
//

import Foundation
import UIKit
import AVKit


class ImageToVideo{
    static func getVideo(for image: UIImage, durationInSeconds: Int, completion: @escaping (URL) -> Void){
        
        //create a CIImage
        guard let staticImage = CIImage(image: image) else {
            print("---->> core image conversion failed at \(#function)")
            return}
        
        //create a variable to hold the pixelBuffer
        var pixelBuffer: CVPixelBuffer?
        //set some standard attributes
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
             kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        //create the width and height of the buffer to match the image
        let width:Int = Int(staticImage.extent.size.width)
        let height:Int = Int(staticImage.extent.size.height)
        //create a buffer (notice it uses an in/out parameter for the pixelBuffer variable)
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32BGRA,
                            attrs,
                            &pixelBuffer)
        //create a CIContext
        let context = CIContext()
        //use the context to render the image into the pixelBuffer
        context.render(staticImage, to: pixelBuffer!)
        
        
        
        
        
        let assetWriterSettings = [AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey : 400, AVVideoHeightKey: 400] as [String : Any]
        
        
        
        let imageName = String().getRandomName(length: 6)
        
        //generate a file url to store the video. some_image.jpg becomes some_image.mov
        guard let imageNameRoot = imageName.split(separator: ".").first, let outputMovieURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(imageNameRoot).mov") else {
            print("----->> url generation issue at \(#function)")
            return
        }
        //delete any old file
        if FileManager.default.fileExists(atPath: outputMovieURL.absoluteString){
            do {
                try FileManager.default.removeItem(at: outputMovieURL)
            } catch {
                print("Could not remove file \(error.localizedDescription)")
            }
        }
        //create an assetwriter instance
        guard let assetwriter = try? AVAssetWriter(outputURL: outputMovieURL, fileType: .mov) else {
            abort()
        }
        //generate 1080p settings
        let settingsAssistant = AVOutputSettingsAssistant(preset: .preset1920x1080)?.videoSettings
        //create a single video input
        let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: settingsAssistant)
        //create an adaptor for the pixel buffer
        let assetWriterAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: nil)
        //add the input to the asset writer
        assetwriter.add(assetWriterInput)
        //begin the session
        assetwriter.startWriting()
        assetwriter.startSession(atSourceTime: CMTime.zero)
        //determine how many frames we need to generate
        let framesPerSecond = 30
        //duration is the number of seconds for the final video
        let totalFrames = durationInSeconds * framesPerSecond
        var frameCount = 0
        while frameCount < totalFrames {
            if assetWriterInput.isReadyForMoreMediaData {
                let frameTime = CMTimeMake(value: Int64(frameCount), timescale: Int32(framesPerSecond))
                //append the contents of the pixelBuffer at the correct time
                assetWriterAdaptor.append(pixelBuffer!, withPresentationTime: frameTime)
                frameCount+=1
            }
        }
        //close everything
        assetWriterInput.markAsFinished()
        assetwriter.finishWriting {
            pixelBuffer = nil
            //outputMovieURL now has the video
            completion(outputMovieURL)
            print("---->> Finished video location: \(outputMovieURL)")
        }
        
        
    }
}

