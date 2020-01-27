import UIKit

class CustomImageView: UIImageView {

    class Downloader {
        
        static let shared: Downloader = Downloader()
        
        let session: URLSession
        
        init() {
            let mb = 1024 * 1024
            
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.urlCache = URLCache(memoryCapacity: 5 * mb, diskCapacity: 75 * mb, diskPath: nil)
            sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
            
            session = URLSession(configuration: sessionConfiguration)
        }
        
    }
    
    @IBInspectable
    var placeholderImage: UIImage? = nil
    
    @IBInspectable
    var maxWidth: CGFloat = 0.0
    
    @IBInspectable
    var activityIndicator: Bool = false
    
    @IBInspectable
    var transition: Bool = false
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0
    
    @IBInspectable
    var cornerRadiusMode: Int = 0
    
    @IBInspectable
    var dontScaleImage: Bool = false
    
    @IBInspectable
    var imageMaximumRatio: CGFloat = 0.0
    
    override var image: UIImage? {
        didSet {
            if imageMaximumRatio > 0.0 {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if imageMaximumRatio > 0.0, let img = self.image {
            let imgWidth = img.size.width
            let imgHeight = img.size.height
            let viewWidth = self.frame.size.width
            
            let ratio = min(imageMaximumRatio, viewWidth / imgWidth)
            let scaledHeight = imgHeight * ratio
            
            return CGSize(width: viewWidth, height: scaledHeight)
        }
        
        return super.intrinsicContentSize
    }
    
    weak var task: URLSessionTask? = nil
    
    deinit {
        cancel()
    }
    
    func imageFrom(file: URL, cache: NSCache<AnyObject, UIImage>, completion: ((UIImage?) -> Void)? = nil) {
        cancel()
        
        if let cachedImage = cache.object(forKey: file as AnyObject) {
            image = cachedImage
            return
        }
        
        image = placeholderImage
        
        if activityIndicator {
            setActivityIndicator(visible: true)
        }
        
        let imageScaleDisabled: Bool = dontScaleImage
        let imageMaxWidth: CGFloat = maxWidth
        let imageCornerRadius: CGFloat = cornerRadius
        let imageCornerRadiusMode: Int = cornerRadiusMode
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            guard var image = UIImage(contentsOfFile: file.path) else {
                DispatchQueue.main.async {
                    if self.activityIndicator {
                        self.setActivityIndicator(visible: false)
                    }
                    
                    completion?(nil)
                }
                return
            }
            
            if !imageScaleDisabled, imageMaxWidth > 0.0 {
                image = image.scaledImageTo(width: imageMaxWidth)
            }
            
            if imageCornerRadius < 0.0 {
                image = image.circleImage()
            } else if imageCornerRadius > 0.0 {
                switch imageCornerRadiusMode {
                case 1:
                    image = image.roundedImage(with: imageCornerRadius, corners: [.topLeft, .topRight])
                case 2:
                    image = image.roundedImage(with: imageCornerRadius, corners: [.bottomLeft, .bottomRight])
                default:
                    image = image.roundedImage(with: imageCornerRadius)
                }
            }
            
            DispatchQueue.main.async {
                cache.setObject(image, forKey: file as AnyObject)
                
                if self.activityIndicator {
                    self.setActivityIndicator(visible: false)
                }
                
                self.setImage(image, transition: self.transition)
                
                completion?(image)
            }
        }
    }
    
    func imageFrom(url: URL, cache: NSCache<AnyObject, UIImage>, completion: ((UIImage?) -> Void)? = nil) {
        cancel()
        
        if let cachedImage = cache.object(forKey: url as AnyObject) {
            image = cachedImage
            return
        }
        
        image = placeholderImage
        
        if activityIndicator {
            setActivityIndicator(visible: true)
        }
        
        let imageScaleDisabled: Bool = dontScaleImage
        let imageMaxWidth: CGFloat = maxWidth
        let imageCornerRadius: CGFloat = cornerRadius
        let imageCornerRadiusMode: Int = cornerRadiusMode
        
        let urlTask = Downloader.shared.session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            guard error == nil,
                let r = response as? HTTPURLResponse, r.statusCode == 200,
                let d = data,
                var image = UIImage(data: d) else {
                    DispatchQueue.main.async {
                        if self.activityIndicator {
                            self.setActivityIndicator(visible: false)
                        }
                        
                        completion?(nil)
                    }
                    return
            }
            
            if !imageScaleDisabled, imageMaxWidth > 0.0 {
                image = image.scaledImageTo(width: imageMaxWidth)
            }
            
            if imageCornerRadius < 0.0 {
                image = image.circleImage()
            } else if imageCornerRadius > 0.0 {
                switch imageCornerRadiusMode {
                case 1:
                    image = image.roundedImage(with: imageCornerRadius, corners: [.topLeft, .topRight])
                case 2:
                    image = image.roundedImage(with: imageCornerRadius, corners: [.bottomLeft, .bottomRight])
                default:
                    image = image.roundedImage(with: imageCornerRadius)
                }
            }
            
            DispatchQueue.main.async {
                cache.setObject(image, forKey: url as AnyObject)
                
                if self.activityIndicator {
                    self.setActivityIndicator(visible: false)
                }
                
                self.setImage(image, transition: self.transition)
                
                completion?(image)
            }
        }
        
        urlTask.resume()
        task = urlTask
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
