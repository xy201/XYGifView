
import UIKit
import ImageIO
import QuartzCore

class XYView: UIView {
    private var gifurl:NSURL!
    private var totalTime:Float=0
    private var imageArray:Array<CGImage>=[]
    private var timeArray:Array<NSNumber>=[]
    
    
    var width:CGFloat {
        return self.frame.size.width
    }
    var height:CGFloat {
        return self.frame.size.height
    }
    
    /*
     加载本地gif图
     - parameter name: gif图片名称
     */
    func showGifImageWithLocalName(name:String){
        gifurl = Bundle.main.url(forResource: name, withExtension: "gif") as NSURL!
        self.createFrame()
    }
    func createFrame() {
        let url:CFURL = gifurl as CFURL
        let gifsource = CGImageSourceCreateWithURL(url, nil)
        let imageCount = CGImageSourceGetCount(gifsource!)
        for i in 0..<imageCount {
            let imageRef = CGImageSourceCreateImageAtIndex(gifsource!, i, nil)
            
            imageArray.append(imageRef!)
            
            let sourceDict = CGImageSourceCopyPropertiesAtIndex(gifsource!, i, nil) as! NSDictionary
            let imageWidth = sourceDict[String(kCGImagePropertyPixelWidth)] as! NSNumber
            let imageHeight = sourceDict[String(kCGImagePropertyPixelHeight)] as! NSNumber
            if imageWidth.floatValue/imageHeight.floatValue != Float(width/height) {
                self.fitScale(imageWith: CGFloat(imageWidth.floatValue), imageHeight: CGFloat(imageHeight.floatValue))
            }
            let gifDict = sourceDict[String(kCGImagePropertyGIFDictionary)] as! NSDictionary
            let time = gifDict[String(kCGImagePropertyGIFDelayTime)] as! NSNumber
            timeArray.append(time)
            totalTime += time.floatValue
        }
        self.showAnimation()
    }
    /**
      适应长宽比
     
      - parameter imageWidth:  图片的宽
      - parameter imageHeight: 图片的高
     **/
    func fitScale(imageWith:CGFloat,imageHeight:CGFloat) {
        var newWidth:CGFloat
        var newHeight:CGFloat
        if imageWith/imageHeight > width/height {
            newWidth  = width
            newHeight = width/(imageWith/imageHeight)
        }else {
            newWidth = height*(imageWith/imageHeight)
            newHeight = height
        }
        let point:CGPoint = self.center
        self.frame.size = CGSize(width:newWidth,height:newHeight)
        self.center = point
    }
    func showAnimation(){
        let animation = CAKeyframeAnimation(keyPath: "contents")
        var current:Float = 0
        var timeKeys:Array<NSNumber> = []
        for time in timeArray {
            timeKeys.append(NSNumber(value:Float(current/totalTime)))
            current+=time.floatValue
        }
        animation.keyTimes = timeKeys
        animation.values = imageArray
        animation.duration = TimeInterval(totalTime)
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        self.layer.add(animation,forKey: "XYView")
    }
    
}
