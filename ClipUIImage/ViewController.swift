//
//  ViewController.swift
//  ClipUIImage
//
//  Created by Masaki Horimoto on 2015/11/11.
//  Copyright © 2015年 Masaki Horimoto. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var imageViewFromLibrary: UIImageView!
    @IBOutlet weak var clipSegControl: UISegmentedControl!
    
    //clipTypeをenumで定義しておく(一個だけだけど練習)
    enum clipType :Int {
        case type100x100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     UIImageをセットする
     */
    func setImage() {
        imageViewFromLibrary.contentMode = .ScaleAspectFit
        imageViewFromLibrary.image = UIImage(named: "mountain.jpg")
        let scale = imageViewFromLibrary.image?.scale
        print("scale\(scale)")
    }
    
    /**
     UIImageを切り取る
     
     - parameter image:切り取り対象(UIImage)
     - parameter rect:切り取る大きさと座標位置(CGRect)
     - returns: 切り取り結果(UIImage)
    */
    func clipImage(image: UIImage?, rect: CGRect?) -> UIImage? {
        
        guard let originalImage = image else {
            return nil
        }
        
        guard let rct = rect else {
            return image
        }
        
        // ソース画像からCGImageを取り出し、指定された範囲を切り抜いたCGImageを生成
        let cripImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, rct)
        
        guard let imgrf = cripImageRef else {
            return image
        }

        //生成したCGImageをUIImageとする
        let crippedImage = UIImage(CGImage: imgrf)
        
        return crippedImage
        
    }
    
    
    /**
     Clip用のSegControlを押下した時
     */
    @IBAction func pressClipSegControl(sender: AnyObject) {
        
        var rect :CGRect?       //切り取るrect値格納用
        
        //セグコントロールとclipTypeを紐付け。そしてその値がnilになる場合(= Non Clip)には元のイメージを表示する
        let clipValues : [clipType?] = [nil, .type100x100]
        guard let clipValue = clipValues[clipSegControl.selectedSegmentIndex] else {
            setImage()
            return
        }

        //セグコントロールが.type100x100(= Clip(100x100))の時、それに従ったrectの値を入れる
        switch clipValue {
        case .type100x100:
            let origin = CGPoint(x: 100, y: 250)        //座標位置(四隅の左上)は(100,100)
            let size = CGSize(width: 100, height: 100)  //切り取りサイズは100x100
            rect = CGRect(origin: origin, size: size)   //originとsizeからrectを割り出す
        }
        
        //上で作成したrectに従って指定したUIImageを切り取る。今回きりとるUIImageはimageViewFromLibrary.image
        let clippedImage = clipImage(imageViewFromLibrary.image, rect: rect)    //clippedImageには切り取り結果が入る

        //clippedImageがnilの場合には元のイメージを表示する
        guard let clpImg = clippedImage else {
            setImage()
            return
        }
        
        //きりとったUIImageを表示する
        imageViewFromLibrary.image = clpImg
    }
    

    
}

