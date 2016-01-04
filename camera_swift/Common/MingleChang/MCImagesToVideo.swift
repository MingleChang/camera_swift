//
//  MCImagesToVideo.swift
//  camera_swift
//
//  Created by cjw on 16/1/4.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

import UIKit
import AVFoundation



class MCImagesToVideo: NSObject {
    static let DefaultFrameSize=CGSizeMake(480, 320)
    static let DefaultFrameRate=1
    static let TransitionFrameCount=50
    static let FramesToWaitBeforeTransition=40
    
    
    class func writeImageAsMovie(array:[UIImage], path:String, size:CGSize, fps:Int, shouldAnimateTransitions:Bool,callBack:successBlock?){
        do{
            let videoWriter=try AVAssetWriter(URL: NSURL(fileURLWithPath: path), fileType: AVFileTypeMPEG4)
            
            let videoSettings:[String:AnyObject]=[AVVideoCodecKey:AVVideoCodecH264,AVVideoWidthKey:size.width,AVVideoHeightKey:size.height]
            
            let writerInput=AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSettings)
            
            let adaptor=AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: videoSettings)
            
            assert(videoWriter.canAddInput(writerInput))
            videoWriter.addInput(writerInput)
            
            //Start a session:
            let a=videoWriter.startWriting()
            videoWriter.startSessionAtSourceTime(kCMTimeZero)
            assert(a)
            
            assert(adaptor.pixelBufferPool != nil)
            
            var buffer:CVPixelBufferRef?=nil
            CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, adaptor.pixelBufferPool!, &buffer)
            
            var presentTime=CMTime(value: 0, timescale: Int32(fps))
            var i=0
            
            while(true){
                if(writerInput.readyForMoreMediaData){
                    presentTime=CMTime(value: Int64(i), timescale: Int32(fps))
                    if(i >= array.count){
                        buffer=nil
                    }else{
                        buffer=MCImagesToVideo.pixelBufferFromCGImage(array[i].CGImage!, size: size)
                    }
                    
                    if let validBuffer = buffer{
                        let appendSuccess=MCImagesToVideo.appendToAdaptor(adaptor, pixelBuffer: validBuffer, atTime: presentTime, withInput: writerInput)
                        
                        assert(appendSuccess, "Failed to append")
                        if (shouldAnimateTransitions == true) && (i+1<array.count){
                            let fadeTime=CMTimeMake(1, Int32(fps*TransitionFrameCount))
                            for var b = 0; b < FramesToWaitBeforeTransition; b++ {
                                presentTime = CMTimeAdd(presentTime, fadeTime)
                            }
                            let framesToFadeCount = TransitionFrameCount - FramesToWaitBeforeTransition;
                            for var j=1; j<framesToFadeCount;j++ {
                                buffer=MCImagesToVideo.crossFadeImage(array[i].CGImage!, toImage: array[i+1].CGImage!, atSize: size, withAlpha: CGFloat(j)/CGFloat(framesToFadeCount))
                                let appendSuccess=MCImagesToVideo.appendToAdaptor(adaptor, pixelBuffer: buffer!, atTime: presentTime, withInput: writerInput)
                                presentTime = CMTimeAdd(presentTime, fadeTime)
                                assert(appendSuccess, "Failed to append")
                            }
                        }
                        i++
                    }else{
                        writerInput.markAsFinished()
                        videoWriter.finishWritingWithCompletionHandler({ () -> Void in
                            if (videoWriter.status == AVAssetWriterStatus.Completed){
                                if let block = callBack{
                                    block(true)
                                }
                            }else{
                                if let block = callBack{
                                    block(false)
                                }
                            }
                        })
                        break
                    }
                }
            }
        }catch{
            if let block = callBack{
                block(false)
            }
            return
        }
    }
    
    class func pixelBufferFromCGImage(image:CGImageRef,size imageSize:CGSize) -> CVPixelBufferRef {
        let options:[NSObject:AnyObject]=[kCVPixelBufferCGImageCompatibilityKey:true,kCVPixelBufferCGBitmapContextCompatibilityKey:true]
        var pixelBuffer: CVPixelBuffer? = nil
        let status=CVPixelBufferCreate(kCFAllocatorDefault, Int(imageSize.width), Int(imageSize.height), OSType(kCVPixelFormatType_32ARGB), options, &pixelBuffer)
        
        assert(status == kCVReturnSuccess && pixelBuffer != nil)
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, 0)
        let pxdata=CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        assert(pxdata != nil)
        
        let rgbColorSpace=CGColorSpaceCreateDeviceRGB()
        let context=CGBitmapContextCreate(pxdata, Int(imageSize.width), Int(imageSize.height), 8, 4*Int(imageSize.width), rgbColorSpace, CGImageAlphaInfo.NoneSkipFirst.rawValue)
        
        assert(context != nil)
        
        let drawRect = CGRectMake(0 + (imageSize.width - CGFloat(CGImageGetWidth(image)))/2, (imageSize.height - CGFloat(CGImageGetHeight(image)))/2, CGFloat(CGImageGetWidth(image)), CGFloat(CGImageGetHeight(image)))
        
        CGContextDrawImage(context, drawRect, image)
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, 0)
        return pixelBuffer!
    }
    
    class func crossFadeImage(baseImage:CGImageRef,toImage fadeInImage:CGImageRef,atSize imageSize:CGSize,withAlpha alpha:CGFloat) -> CVPixelBufferRef {
        let options:[NSObject:AnyObject]=[kCVPixelBufferCGImageCompatibilityKey:true,kCVPixelBufferCGBitmapContextCompatibilityKey:true]
        var pixelBuffer: CVPixelBuffer? = nil
        let status=CVPixelBufferCreate(kCFAllocatorDefault, Int(imageSize.width), Int(imageSize.height), OSType(kCVPixelFormatType_32ARGB), options, &pixelBuffer)
        
        assert(status == kCVReturnSuccess && pixelBuffer != nil)
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, 0)
        let pxdata=CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        assert(pxdata != nil)
        
        let rgbColorSpace=CGColorSpaceCreateDeviceRGB()
        let context=CGBitmapContextCreate(pxdata, Int(imageSize.width), Int(imageSize.height), 8, 4*Int(imageSize.width), rgbColorSpace, CGImageAlphaInfo.NoneSkipFirst.rawValue)
        
        assert(context != nil)
        
        let drawRect = CGRectMake(0 + (imageSize.width - CGFloat(CGImageGetWidth(baseImage)))/2, (imageSize.height - CGFloat(CGImageGetHeight(baseImage)))/2, CGFloat(CGImageGetWidth(baseImage)), CGFloat(CGImageGetHeight(baseImage)))
        
        CGContextDrawImage(context, drawRect, baseImage)
        
        CGContextBeginTransparencyLayer(context, nil)
        CGContextSetAlpha(context, alpha)
        CGContextDrawImage(context, drawRect, fadeInImage)
        CGContextEndTransparencyLayer(context)
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, 0)
        return pixelBuffer!
    }
    
    class func appendToAdaptor(adaptor:AVAssetWriterInputPixelBufferAdaptor,pixelBuffer buffer:CVPixelBufferRef,atTime presentTime:CMTime,withInput writerInput:AVAssetWriterInput) -> Bool {
        while(!writerInput.readyForMoreMediaData){
            usleep(1)
        }
        
        return adaptor.appendPixelBuffer(buffer, withPresentationTime: presentTime)
    }
}
