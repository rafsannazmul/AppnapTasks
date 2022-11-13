//
//  VideoMerging.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/12/22.
//

import Foundation
import UIKit
import AVKit

class VideoMerging{
    
    static func merge(videos:[URL], completion: @escaping (URL) -> Void){
        var movieAssets : [AVAsset] = []
        var videoTrackWidths : [CGFloat] = []
        var videoTrackHeights : [CGFloat] = []
        for video in videos {
            let movieAsset = AVAsset(url: video)
            movieAssets.append(movieAsset)
            videoTrackWidths.append(movieAsset.tracks(withMediaType: .video)[0].naturalSize.width)
            videoTrackHeights.append(movieAsset.tracks(withMediaType: .video)[0].naturalSize.height)
        }
        
        let movieFrameSize : CGSize = CGSize(width: videoTrackWidths.max()!, height: videoTrackHeights.max()!)
        let mutableComposition = AVMutableComposition()
        // Transition relate
        let timeOffsetBetweenVideos = CMTimeMakeWithSeconds(0.3, preferredTimescale: 30)
        let videoCompositionInstruction = AVMutableVideoCompositionInstruction()
        let compositionAudioTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        var lastVideoEndTime = CMTime.zero
        
        for (index, asset) in movieAssets.enumerated(){
            // Add video track into composition
            let videoStartTime = CMTimeCompare(lastVideoEndTime, CMTime.zero) == 0 ? CMTime.zero : CMTimeSubtract(lastVideoEndTime, timeOffsetBetweenVideos)
            let compositionVideoTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
            let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
            do {
                try compositionVideoTrack!.insertTimeRange(videoTrack.timeRange, of: videoTrack, at: videoStartTime)
            } catch {
                print("-------->>1")
            }
            
            if index == (movieAssets.count - 1) {
                compositionVideoTrack?.scaleTimeRange(videoTrack.timeRange, toDuration: CMTimeAdd(asset.duration, timeOffsetBetweenVideos))
            }
            
            // Add audio track into composition
            if let track = asset.tracks(withMediaType: .audio).first {
                
                do {
                    try compositionAudioTrack?.insertTimeRange(track.timeRange, of: track, at: videoStartTime)
                } catch {
                    print("error")
                }
                
            } else {
                print("no audio detected")
            }
            
            
            if movieAssets.count == 1 {
                break
            }
            if index == 0 {
                // First movie has ending animation only
                let transitionTimeRange = CMTimeRangeMake(start: CMTimeSubtract(compositionVideoTrack!.timeRange.end, timeOffsetBetweenVideos), duration: timeOffsetBetweenVideos)
                let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
                let transform = videoTrack.preferredTransform.translatedBy(x: movieFrameSize.width / -1.0, y: 0)
                layerInstruction.setTransformRamp(fromStart: videoTrack.preferredTransform, toEnd: transform, timeRange: transitionTimeRange)
                layerInstruction.setOpacity(0.0, at: compositionVideoTrack!.timeRange.end)
                
                videoCompositionInstruction.layerInstructions.append(layerInstruction)
            } else if index == (movieAssets.count - 1) {
                // Last movie has begining animation only
                let transitionTimeRange = CMTimeRangeMake(start: lastVideoEndTime, duration: timeOffsetBetweenVideos)
                let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
                var transform = videoTrack.preferredTransform.scaledBy(x: 0.5, y: 0.5)
                transform = transform.translatedBy(x: movieFrameSize.width / 2, y: movieFrameSize.height / 2)
                layerInstruction.setTransformRamp(fromStart: transform, toEnd: videoTrack.preferredTransform, timeRange: transitionTimeRange)
                
                videoCompositionInstruction.layerInstructions.append(layerInstruction)
            } else {
                // Other movies has both begining/ending animation
                let transitionTimeRangeBegin = CMTimeRangeMake(start: lastVideoEndTime, duration: timeOffsetBetweenVideos)
                let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
                var transformBegin = videoTrack.preferredTransform.scaledBy(x: 0.5, y: 0.5)
                transformBegin = transformBegin.translatedBy(x: movieFrameSize.width / 2, y: movieFrameSize.height / 2)
                layerInstruction.setTransformRamp(fromStart: transformBegin, toEnd: videoTrack.preferredTransform, timeRange: transitionTimeRangeBegin)
                
                let transitionTimeRangeEnd = CMTimeRangeMake(start: CMTimeSubtract(compositionVideoTrack!.timeRange.end, timeOffsetBetweenVideos), duration: timeOffsetBetweenVideos)
                let transform = videoTrack.preferredTransform.translatedBy(x: movieFrameSize.width / -1.0, y: 0)
                layerInstruction.setTransformRamp(fromStart: videoTrack.preferredTransform, toEnd: transform, timeRange: transitionTimeRangeEnd)
                layerInstruction.setOpacity(0.0, at: compositionVideoTrack!.timeRange.end)
                
                videoCompositionInstruction.layerInstructions.append(layerInstruction)
            }
            
            lastVideoEndTime = CMTimeSubtract(compositionVideoTrack!.timeRange.end, timeOffsetBetweenVideos)
        }
        
        let imageName : String? = String().getRandomName(length: 10)
        //generate a file url to store the video. some_image.jpg becomes some_image.mov
        guard let imageNameRoot = imageName!.split(separator: ".").first, let outputMovieURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(imageNameRoot).mov") else {
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
        
        let retFileUrl = outputMovieURL
        
        
        
        
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        let filterLayer = CALayer()
        
        parentLayer.frame = CGRect(origin: .zero, size: mutableComposition.naturalSize)
        videoLayer.frame = CGRect(origin: .zero, size: mutableComposition.naturalSize)
        parentLayer.addSublayer(videoLayer)
        
        
        
        filterLayer.frame = CGRect(origin: .zero, size: mutableComposition.naturalSize)
        videoLayer.addSublayer(filterLayer)
        
        if let filter = CIFilter(name: "CISepiaTone"){
            filter.setDefaults()
            videoLayer.backgroundFilters = [filter]
        }
        
        
        
        
        
        let exportSesstion = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPresetHighestQuality)
        exportSesstion?.outputFileType = AVFileType.mov
        exportSesstion?.outputURL = retFileUrl
        if movieAssets.count > 1 {
            videoCompositionInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: mutableComposition.duration)
            videoCompositionInstruction.enablePostProcessing = false
            
            let videoComposition = AVMutableVideoComposition(propertiesOf: mutableComposition)
            videoComposition.instructions = [videoCompositionInstruction]
            videoComposition.renderSize = mutableComposition.naturalSize
            videoComposition.renderScale = 1.0
            videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
            videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            exportSesstion?.videoComposition = videoComposition
        }
        exportSesstion?.exportAsynchronously(completionHandler: { () -> Void in
            if exportSesstion?.status == AVAssetExportSession.Status.completed {
                print("Video file exported: \(retFileUrl)")
                completion(retFileUrl)
            } else {
                print(exportSesstion!.error!)
                print("Failed exporting video: \(exportSesstion?.error?.localizedDescription)")
            }
        })
    }
    
}
