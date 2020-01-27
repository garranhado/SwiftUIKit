import UIKit

// MARK: - Scale (retina display, for UI)

extension UIImage {
    
    func scaledImageTo(width: CGFloat) -> UIImage {
        let imageAspectRatio = size.width / size.height
        let height = round(width / imageAspectRatio)
        
        let s = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque(), 0.0)
        draw(in: CGRect(origin: .zero, size: s))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func scaledImageTo(height: CGFloat) -> UIImage {
        let imageAspectRatio = size.width / size.height
        let width = round(height * imageAspectRatio)
        
        let s = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque(), 0.0)
        draw(in: CGRect(origin: .zero, size: s))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func scaledImageTo(fit size: CGSize) -> UIImage {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.width / self.size.width
        } else {
            resizeFactor = size.height / self.size.height
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque(), 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func scaledImageTo(fill size: CGSize) -> UIImage {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.height / self.size.height
        } else {
            resizeFactor = size.width / self.size.width
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque(), 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func scaledImageTo(stretch size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, isOpaque(), 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return image
    }

}

// MARK: Rounded and Circle

extension UIImage {
    
    // divideRadiusByImageScale: true (assets), false (web server)
    func roundedImage(with radius: CGFloat, corners: UIRectCorner = .allCorners, divideRadiusByImageScale: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let scaledRadius = divideRadiusByImageScale ? radius / scale : radius
        
        let clippingPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), byRoundingCorners: corners, cornerRadii: CGSize(width: scaledRadius, height: scaledRadius))
        clippingPath.addClip()
        
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }

    func circleImage() -> UIImage {
        let radius = min(size.width, size.height) / 2.0
        var squareImage = self
        
        if size.width != size.height {
            let squareDimension = min(size.width, size.height)
            let squareSize = CGSize(width: squareDimension, height: squareDimension)
            squareImage = scaledImageTo(fill: squareSize)
        }
        
        UIGraphicsBeginImageContextWithOptions(squareImage.size, false, 0.0)
        
        let clippingPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: squareImage.size),
            cornerRadius: radius
        )
        
        clippingPath.addClip()
        
        squareImage.draw(in: CGRect(origin: CGPoint.zero, size: squareImage.size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

// MARK: - Filter

extension UIImage {
    
    func filteredImage(withFilter name: String, parameters: [String: Any]? = nil) -> UIImage? {
        var image: CoreImage.CIImage? = ciImage
        
        if image == nil, let CGImage = self.cgImage {
            image = CoreImage.CIImage(cgImage: CGImage)
        }
        
        guard let coreImage = image else { return nil }

        let context = CIContext(options: [.priorityRequestLow: true])
        
        var parameters: [String: Any] = parameters ?? [:]
        parameters[kCIInputImageKey] = coreImage

        guard let filter = CIFilter(name: name, parameters: parameters) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        let cgImageRef = context.createCGImage(outputImage, from: outputImage.extent)
        
        return UIImage(cgImage: cgImageRef!, scale: scale, orientation: imageOrientation)
    }
    
    func blurredImage(with radius: UInt) -> UIImage? {
        return filteredImage(withFilter: "CIGaussianBlur", parameters: ["inputRadius": radius])
    }
    
}

// MARK: - Miscellaneous

extension UIImage {
    
    func isOpaque() -> Bool {
        guard let cgi = cgImage else { return false }
        
        let alphaInfo = cgi.alphaInfo
        
        return !(alphaInfo == .first || alphaInfo == .last || alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast)
    }
    
}
