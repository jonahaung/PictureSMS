//
//  Extensions.swift
//  PictureSMS
//
//  Created by Aung Ko Min on 2/4/21.
//

import UIKit
extension UIApplication {
    
    class func getRootViewController() -> UIViewController? {
        var rootVC: UIViewController? = nil
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive {
                rootVC = ((scene as? UIWindowScene)!.delegate as! UIWindowSceneDelegate).window!!.rootViewController
                break
            }
        }
        return rootVC
    }
    class func getTopViewController(base: UIViewController? = UIApplication.getRootViewController()) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension String {
    
    var image: UIImage? {
        if let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
extension UIImage: Identifiable {
    
    var imageString: String? {
        return self.jpegData(compressionQuality: 0.5)?.base64EncodedString(options: .lineLength64Characters)
    }
    
    func scaledWithMaxWidthOrHeightValue(value: CGFloat) -> UIImage? {
        
        let width = self.size.width
        let height = self.size.height
        
        let ratio = width/height
        
        var newWidth = value
        var newHeight = value
        
        if ratio > 1 {
            newWidth = width * (newHeight/height)
        } else {
            newHeight = height * (newWidth/width)
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0)
        
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func scaled(withScale scale: CGFloat) -> UIImage? {
        
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

