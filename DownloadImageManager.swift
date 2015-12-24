//
//  DownloadImageManager.swift
//  05-测试下载操作
//
//  Created by __zimu on 15/12/23.
//  Copyright © 2015年 __zimu. All rights reserved.
//
//  下载图像的管理器

import UIKit

class DownloadImageManager: NSObject {
    //操作缓存池
    var operationCache = [String: NSOperation]()
    //图片缓存池
    var imageCache = NSCache()
    
    let queue = NSOperationQueue()
    
    //单例
    static let instance = DownloadImageManager()
    class func sharedManager() -> DownloadImageManager {
        return instance
    }
    
    func downloadImage(urlString: String, finishBlock:((image: UIImage) -> Void)) {
        //判断缓存池中有没有
        if operationCache[urlString] != nil {
            print("正在下载中...稍安勿躁...")
            return
        }
        //判断沙盒里有没有图像
        if checkImageCache(urlString) {
            finishBlock(image: imageCache.objectForKey(urlString) as! UIImage)
            return
        }
        //定义操作
        let op = DownloadImageOperation.downloadImage(urlString) { (image) -> Void in
            finishBlock(image: image)
            //移除操作
            self.operationCache.removeValueForKey(urlString)
        }
        //把操作添加到缓存池
        operationCache.updateValue(op, forKey: urlString)
        //添加到队列
        queue.addOperation(op)
    }
    
    func cancelDownload(urlString: String?) {
        
        if urlString == nil {
            print("当前没有下载操作")
            return
        }
        //判断缓存池中有没有
        //有
        if let op = operationCache[urlString!] {
            print("取消下载---")
            op.cancel()
            //从缓存池中移除
            operationCache.removeValueForKey(urlString!)
        }
    }
    
    func checkImageCache(urlString: String) -> Bool {
        //检查内存缓存
        if imageCache.objectForKey(urlString) as? UIImage != nil {
            print("内存缓存")
            return true
        }
        //检查沙盒缓存
        if let image = UIImage(contentsOfFile:urlString.docuPath()) {
            print("沙盒缓存")
            //加载到内存
            imageCache.setObject(image, forKey: urlString)
            return true
        }
        return false
    }
    
    
}
