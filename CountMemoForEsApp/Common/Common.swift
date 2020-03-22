//
//  Common.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/09/28.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class Common {

    static var currentNavViewController: UINavigationController?
    static var me: UserModel?

    static func setBorderColor(view: UIView) {
        view.layer.borderColor = Config.GRAY.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
    }

    static func getCurrentViewController(sender : UIView) ->  UIViewController{
        //let sender = UIApplication.sharedApplication().keyWindow?.subviews.last;
        var vc = sender.next;
        while vc != nil && !(vc!.isKind(of: UIViewController.self)) {
            vc = vc!.next;
        }
        return vc as! UIViewController;
    }
    
    static func showErrorAlert(vc: UIViewController, title: String?, message: String) {
        let alert: UIAlertController = UIAlertController(title: title as String?,
                                                         message: message as String,
                                                         preferredStyle: .alert);
        let cancelAction: UIAlertAction = UIAlertAction(title: Config.YES,
                                                        style: .cancel,
                                                        handler: nil)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }

    static func saveImage(imageName: String, image: UIImage) {


     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }

    static func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
    
    static func getRandomColor() -> UIColor{

        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)

        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)

    }
}
