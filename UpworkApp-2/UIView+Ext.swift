//
//  UIView+Ext.swift
//  UpworkApp-2
//
//  Created by Caner Çağrı on 8.10.2022.
//

import UIKit

extension UIView {

    func takeScreenshot() -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
