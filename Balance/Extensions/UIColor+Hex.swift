import UIKit

extension UIColor {
    // Adapted from this example: https://developer.apple.com/library/mac/qa/qa1576/_index.html
    var hexString: String? {
        // Get the red, green, and blue components of the color
        var redFloatValue: CGFloat = 0, greenFloatValue: CGFloat = 0, blueFloatValue: CGFloat = 0
        getRed(&redFloatValue, green: &greenFloatValue, blue: &blueFloatValue, alpha: nil)
        
        // Convert the components to numbers (unsigned decimal integer) between 0 and 255
        let redIntValue = Int(redFloatValue * 255.99999)
        let greenIntValue = Int(greenFloatValue * 255.99999)
        let blueIntValue = Int(blueFloatValue * 255.99999)
        
        // Convert the numbers to hex strings
        let redHexValue = NSString(format: "%02x", redIntValue)
        let greenHexValue = NSString(format: "%02x", greenIntValue)
        let blueHexValue = NSString(format: "%02x", blueIntValue)
        
        // Concatenate the red, green, and blue components' hex strings together with a "#"
        return "#\(redHexValue)\(greenHexValue)\(blueHexValue)"
    }
    
    // Adapted from http://stackoverflow.com/a/27203691/299262
    convenience init?(hexString: String) {
        var trimmedString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if trimmedString.hasPrefix("#") {
            let startIndex = trimmedString.index(trimmedString.startIndex, offsetBy: 1)
            trimmedString = String(trimmedString[startIndex...])
        }
        
        if trimmedString.count != 6 {
            return nil
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: trimmedString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
