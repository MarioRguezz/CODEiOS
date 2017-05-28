//
//  MessageVideo.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 28/06/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import UIKit
import Alamofire
import ImageIO

class MessageVideo: UIViewController {
    
    @IBOutlet weak var videoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let jeremyGif = UIImage.gifImageWithName("Gif")
        self.videoImage.image = jeremyGif
    }
    /*
     //function to return to login view
     @IBAction func leftButtonPressed(sender: AnyObject) {
     let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
     let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
     let centerNav = UINavigationController(rootViewController: nextViewController)
     self.presentViewController(centerNav, animated:true, completion:nil)
     }*/
    
    @IBAction func helpButton(sender: AnyObject) {
        
        publicaPolitica("El video no ha podido descargarse, será descargado una vez que se conecte a una red Wi-Fi")
    }
    
    
    func publicaPolitica(messageBody : String) {
        
        let alertController = UIAlertController(title: "CODE", message:
            messageBody, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    
    
    
    @IBAction func leftButtonPressed(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: nextViewController)
        self.presentViewController(centerNav, animated:true, completion:nil)
    }
}

func localFilePathForUrl(previewUrl: String) -> NSURL? {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    if let url = NSURL(string: previewUrl), let lastPathComponent = url.lastPathComponent {
        let fullPath = documentsPath.stringByAppendingPathComponent(lastPathComponent)
        return NSURL(fileURLWithPath:fullPath)
    }
    return nil
}




extension UIImage {
    
    public class func gifImageWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(gifUrl:String) -> UIImage? {
        guard let bundleURL:NSURL? = NSURL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = NSData(contentsOfURL: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = NSBundle.mainBundle()
            .URLForResource(name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = NSData(contentsOfURL: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionaryRef = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                unsafeAddressOf(kCGImagePropertyGIFDictionary)),
            CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                unsafeAddressOf(kCGImagePropertyGIFUnclampedDelayTime)),
            AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                unsafeAddressOf(kCGImagePropertyGIFDelayTime)), AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImageRef]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(CGImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImageWithImages(frames,
                                                        duration: Double(duration) / 1000.0)
        
        return animation
    }
}


