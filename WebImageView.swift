//
//  WebImageView.swift
//  05-测试下载操作
//
//  Created by __zimu on 15/12/24.
//  Copyright © 2015年 __zimu. All rights reserved.
//

import UIKit

class WebImageView: NSObject {}

extension UIImageView {
    
    //定义私有结构体,目的是为了防止命名污染整个命名空间
    private struct AssociatedKeys{
        static let kWebImageKey = "kWebImageKey"
    }

    //当前下载操作的URL
    //使用关联度细给分类加属性
    var currentURL : String? {
        get
        {
            return objc_getAssociatedObject(self, AssociatedKeys.kWebImageKey) as? String
        }
        
        set(newValue)
        {
            if let newValue = newValue
            {
                objc_setAssociatedObject(
                    self,
                    AssociatedKeys.kWebImageKey,
                    newValue as NSString?,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
    ///  下载网络图片
    ///
    ///  - parameter urlString: 图片地址URL
    func setWebImage(urlString: String) {
        //1.判断是否有下载操作
        if (currentURL?.characters.count > 0) && (urlString != currentURL) {
            
            DownloadImageManager.sharedManager().cancelDownload(currentURL)
            //清空图片
            self.image = nil
        }
        //记录当前下载
        currentURL = urlString
        DownloadImageManager.sharedManager().downloadImage(urlString) { (image) -> Void in
            self.image = image
        }
    }
}