import UIKit
import CoreImage

struct QRCode {
    static func generate(fromString string: String, size: CGFloat) -> UIImage? {
        return generate(fromString: string, size: CGSize(width: size, height: size))
    }
    
    static func generate(fromString string: String, size: CGSize) -> UIImage? {
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setValue(string.data(using: .utf8), forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
       
        if let minimalQRimage = qrFilter.outputImage {
            // NOTE that a QR code is always square, so minimalQRimage.width == .height
            let minimalSideLength = minimalQRimage.extent.width
            let smallestOutputExtent = (size.width < size.height) ? size.width : size.height
            let scaleFactor = (smallestOutputExtent / minimalSideLength) * UIScreen.main.scale
            let scaledImage = minimalQRimage.transformed(by: CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
            
            return UIImage(ciImage: scaledImage, scale: UIScreen.main.scale, orientation: .up)
        }
        return nil
    }
}
