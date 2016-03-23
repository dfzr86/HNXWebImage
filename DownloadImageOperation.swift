//
//  DownloadImageOperation.swift
//  02-自定义操作
//
//  Created by __zimu on 15/12/23.
//  Copyright © 2015年 __zimu. All rights reserved.
//
//  自定义操作,用于下载图片

import UIKit



class DownloadImageOperation: NSOperation {
    //下载图像的url
    private var URLString : String?
    //回调block
    private var finishBlock : ((image: UIImage) -> Void)?
    
    class func downloadImage(urlString: String, finish:((image: UIImage)->Void)) -> DownloadImageOperation {
        let op = DownloadImageOperation()
        op.URLString = urlString
        op.finishBlock = finish
        print("网络下载")
        return op
    }
    
    override func main() {
        autoreleasepool { () -> () in
            assert(URLString != nil, "图像的地址不能为空")
            assert(finishBlock != nil, "必须传入回调")
            
            let url = NSURL(string: URLString!)
            let data = NSData(contentsOfURL: url!)
            
            if data == nil {
                print("图片下载失败,请检查您的url地址是否正确")
                return
            }
            //将图片保存到沙盒目录

            data!.writeToFile(URLString!.docuPath(), atomically: true)
            
            //判断操作是否被取消
            if self.cancelled {
                print("操作被取消", url)
                return
            }
            //主线程回调
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if self.finishBlock != nil {
                    self.finishBlock!(image:UIImage(data: data!)!)
                }
            })
        }
        
    }
}
