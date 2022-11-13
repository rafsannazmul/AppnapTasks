//
//  VideoFilterComposting.swift
//  AppnapTasks
//
//  Created by Rafsan Nazmul on 11/13/22.
//

import Foundation
import AVKit

class VideoFilterCompositor: NSObject, AVVideoCompositing {

    var sourcePixelBufferAttributes: [String : Any]? = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    var requiredPixelBufferAttributesForRenderContext: [String : Any] = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    private var renderContext: AVVideoCompositionRenderContext?

    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
        renderContext = newRenderContext
    }

    func cancelAllPendingVideoCompositionRequests() {
    }

    private let filter = CIFilter(name: "CIPhotoEffectNoir")!
    private let context = CIContext()
    func startRequest(_ asyncVideoCompositionRequest: AVAsynchronousVideoCompositionRequest) {
        guard let track = asyncVideoCompositionRequest.sourceTrackIDs.first?.int32Value, let frame = asyncVideoCompositionRequest.sourceFrame(byTrackID: track) else {
            asyncVideoCompositionRequest.finish(with: NSError(domain: "VideoFilterCompositor", code: 0, userInfo: nil))
            return
        }
        filter.setValue(CIImage(cvPixelBuffer: frame), forKey: kCIInputImageKey)
        if let outputImage = filter.outputImage, let outBuffer = renderContext?.newPixelBuffer() {
            context.render(outputImage, to: outBuffer)
            asyncVideoCompositionRequest.finish(withComposedVideoFrame: outBuffer)
        } else {
            asyncVideoCompositionRequest.finish(with: NSError(domain: "VideoFilterCompositor", code: 0, userInfo: nil))
        }
    }

}
