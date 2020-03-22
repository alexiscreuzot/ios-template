//
//  UIImage+Extensions.swift
//  coreml-FNS
//
//  Created by Alexis Creuzot on 19/03/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import UIKit
import VideoToolbox
import Accelerate

extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    // Misc
    
    func flipped() -> UIImage {
        if self.imageOrientation == .right {
            return UIImage(cgImage: self.cgImage!, scale: UIScreen.main.scale, orientation: .leftMirrored)
        } else if self.imageOrientation == .down {
            return UIImage(cgImage: self.cgImage!, scale: UIScreen.main.scale, orientation: .downMirrored)
        } else if self.imageOrientation == .up {
            return UIImage(cgImage: self.cgImage!, scale: UIScreen.main.scale, orientation: .upMirrored)
        } else if self.imageOrientation == .left {
            return UIImage(cgImage: self.cgImage!, scale: UIScreen.main.scale, orientation: .rightMirrored)
        }
        return self
    }
    
    func imageWithSize(size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        
        //max - scaleAspectFill | min - scaleAspectFit
        let aspectRatio:CGFloat = max(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func averageColor() -> UIColor {
        
            var bitmap = [UInt8](repeating: 0, count: 4)
            
            let context = CIContext(options: nil)
            let cgImg = context.createCGImage(CoreImage.CIImage(cgImage: self.cgImage!), from: CoreImage.CIImage(cgImage: self.cgImage!).extent)
            
            let inputImage = CIImage(cgImage: cgImg!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
            
            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
            
            // Compute result.
            let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
            return result
        }

    // Mark: - Effects

public func applyBlur(_ blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
    func preconditionsValid() -> Bool {
        if size.width < 1 || size.height < 1 {
            log.error("error: invalid image size: (\(size.width), \(size.height). Both width and height must >= 1)")
            return false
        }
        if cgImage == nil {
            log.error("error: image must be backed by a CGImage")
            return false
        }
        if let maskImage = maskImage {
            if maskImage.cgImage == nil {
                log.error("error: effectMaskImage must be backed by a CGImage")
                return false
            }
        }
        return true
    }
    
    guard preconditionsValid() else {
        return nil
    }
    
    let hasBlur = blurRadius > CGFloat.ulpOfOne
    let hasSaturationChange = abs(saturationDeltaFactor - 1) > CGFloat.ulpOfOne
    
    let inputCGImage = cgImage!
    let inputImageScale = scale
    let inputImageBitmapInfo = inputCGImage.bitmapInfo
    let inputImageAlphaInfo = CGImageAlphaInfo(rawValue: inputImageBitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
    
    let outputImageSizeInPoints = size
    let outputImageRectInPoints = CGRect(origin: CGPoint.zero, size: outputImageSizeInPoints)
    
    let useOpaqueContext = inputImageAlphaInfo == Optional.none || inputImageAlphaInfo == .noneSkipLast || inputImageAlphaInfo == .noneSkipFirst
    UIGraphicsBeginImageContextWithOptions(outputImageRectInPoints.size, useOpaqueContext, inputImageScale)
    let outputContext = UIGraphicsGetCurrentContext()
    outputContext?.scaleBy(x: 1, y: -1)
    outputContext?.translateBy(x: 0, y: -outputImageRectInPoints.height)
    
    if hasBlur || hasSaturationChange {
        var effectInBuffer = vImage_Buffer()
        var scratchBuffer1 = vImage_Buffer()
        var inputBuffer: UnsafeMutablePointer<vImage_Buffer>
        var outputBuffer: UnsafeMutablePointer<vImage_Buffer>
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          bitsPerPixel: 32,
                                          colorSpace: nil,
                                          bitmapInfo: bitmapInfo,
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: .defaultIntent)
        
        let error = vImageBuffer_InitWithCGImage(&effectInBuffer, &format, nil, inputCGImage, vImage_Flags(kvImagePrintDiagnosticsToConsole))
        if error != kvImageNoError {
            log.error("error: vImageBuffer_InitWithCGImage returned error code \(error)")
            UIGraphicsEndImageContext()
            return nil
        }
        
        vImageBuffer_Init(&scratchBuffer1, effectInBuffer.height, effectInBuffer.width, format.bitsPerPixel, vImage_Flags(kvImageNoFlags))
        inputBuffer = withUnsafeMutablePointer(to: &effectInBuffer, { (address) -> UnsafeMutablePointer<vImage_Buffer> in
            return address
        })
        outputBuffer = withUnsafeMutablePointer(to: &scratchBuffer1, { (address) -> UnsafeMutablePointer<vImage_Buffer> in
            return address
        })
        
        if hasBlur {
            var inputRadius = blurRadius * inputImageScale
            if inputRadius - 2 < CGFloat.ulpOfOne {
                inputRadius = 2
            }
            let rad = inputRadius * CGFloat(3) * CGFloat(sqrt(2 * CGFloat.pi))
            
            var radius = UInt32(floor(rad / 4 + 0.5) / 2)
            radius |= 1
            
            let flags = vImage_Flags(kvImageGetTempBufferSize) | vImage_Flags(kvImageEdgeExtend)
            let tempBufferSize: Int = vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, nil, 0, 0, radius, radius, nil, flags)
            let tempBuffer = malloc(tempBufferSize)
            
            vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
            vImageBoxConvolve_ARGB8888(outputBuffer, inputBuffer, tempBuffer, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
            vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
            
            free(tempBuffer)
            
            let temp = inputBuffer
            inputBuffer = outputBuffer
            outputBuffer = temp
        }
        
        if hasSaturationChange {
            let s = saturationDeltaFactor
            let floatingPointSaturationMatrix: [CGFloat] = [
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
                ]
            
            let divisor: Int32 = 256
            let matrixSize = floatingPointSaturationMatrix.count
            var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
            for i in 0..<matrixSize {
                saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * CGFloat(divisor)))
            }
            vImageMatrixMultiply_ARGB8888(inputBuffer, outputBuffer, saturationMatrix, divisor, nil, nil, vImage_Flags(kvImageNoFlags))
            
            let temp = inputBuffer
            inputBuffer = outputBuffer
            outputBuffer = temp
        }
        
        let cleanupBuffer: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> Void = {(userData, buf_data) -> Void in
            free(buf_data)
        }
        var effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, cleanupBuffer, nil, vImage_Flags(kvImageNoAllocate), nil)
        if effectCGImage == nil {
            effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, nil, nil, vImage_Flags(kvImageNoFlags), nil)
            free(inputBuffer.pointee.data)
        }
        if let _ = maskImage {
            outputContext?.draw(inputCGImage, in: outputImageRectInPoints)
        }
        
        outputContext?.saveGState()
        if let maskImage = maskImage {
            outputContext?.clip(to: outputImageRectInPoints, mask: maskImage.cgImage!)
        }
        outputContext?.draw(effectCGImage!.takeRetainedValue(), in: outputImageRectInPoints)
        outputContext?.restoreGState()
        
        free(outputBuffer.pointee.data)
    } else {
        outputContext?.draw(inputCGImage, in: outputImageRectInPoints)
    }
    
    if let tintColor = tintColor {
        outputContext?.saveGState()
        outputContext?.setFillColor(tintColor.cgColor)
        outputContext?.fill(outputImageRectInPoints)
        outputContext?.restoreGState()
    }
    
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return outputImage
}
}


