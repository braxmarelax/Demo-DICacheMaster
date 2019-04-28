//
//  ViewController.swift
//  Try5
//
//  Created by MACBOOK PRO on 25/04/2019.
//  Copyright © 2019 DAO Ibrahim. All rights reserved.
//

import UIKit
import DICacheMasterFramework
import Lightbox
import Alamofire
import AlamofireImage

class ViewController: UIViewController {
    
    @IBOutlet weak var uiImageView: UIImageView!
    
    
    @IBOutlet weak var imageurl: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    // MARK: - Action methods
    @IBAction func didTextChange(_ sender: Any) {
         print("text changed")
        
        if let inputText=imageurl.text{
            if(FileCacher.didCacheExist(url: inputText)){
                status.text="Status : Cache exist"
                status.textColor=UIColor(red: 0.0, green: 0.9, blue: 0, alpha: 1.0)
            }
            else{
                status.text="Status : Cache doesn't exist"
                status.textColor=UIColor(red: 0.9, green: 0, blue: 0, alpha: 1.0)
            }
            
        }
        else {
            status.text=""
        }
    }
    
    @IBAction func clearImageView(_ sender: Any) {
        uiImageView.image=nil
    }
    
    @IBAction func cacheimage(_ sender: Any) {
        if let inputText=imageurl.text{
            var cached:Bool=false
            var i:Int=0
            let result=FileCacher.cacheImage(url: imageurl.text, uiImageView: uiImageView)
            
            if(inputText.count>0){
                let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                    if(cached){
                        timer.invalidate()
                        print("Done!!!So stop firing")
                    }
                    if(i==30){
                        timer.invalidate()
                        print("30sec!!!So stop firing")
                    }
                    print("FIRED!!!")
                    if(FileCacher.didCacheExist(url: inputText)){
                        self.status.text="Status : Cache exist"
                        self.status.textColor=UIColor(red: 0.0, green: 0.9, blue: 0, alpha: 1.0)
                        cached=true
                    }
                    else{
                        self.status.text="Status : Cache doesn't exist"
                        self.status.textColor=UIColor(red: 0.9, green: 0, blue: 0, alpha: 1.0)
                    }
                    i+=1
                })
                
            }
        }
    }
    @IBAction func showimage(_ sender: Any) {
        if let inputText=imageurl.text{
            FileCacher.fetchImage(url:inputText, uiImageView: uiImageView)
        }
        
    }
    @IBAction func deletecache(_ sender: Any) {
        // Remove
        var deleted:Bool=false
        var i:Int=0
        if let inputText=imageurl.text{
            if(inputText.count>0){
                let result=FileCacher.deleteCache(url: inputText)
                let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                    if(deleted){
                        timer.invalidate()
                        print("Done!!!So stop firing")
                    }
                    if(i==30){
                        timer.invalidate()
                        print("30sec!!!So stop firing")
                    }
                    print("FIRED!!!")
                    if(FileCacher.didCacheExist(url: inputText)){
                        self.status.text="Status : Cache exist"
                        self.status.textColor=UIColor(red: 0.0, green: 0.9, blue: 0, alpha: 1.0)
                    }
                    else{
                        self.status.text="Status : Cache doesn't exist"
                        self.status.textColor=UIColor(red: 0.9, green: 0, blue: 0, alpha: 1.0)
                        deleted=true
                        self.uiImageView.image=nil
                    }
                    i+=1
                })
            }
            else{
                showToast(message: "Input an image Url please")
            }
        }
    }
    
    @IBOutlet weak var urlToFetch: UITextField!
    
    @IBAction func fetch(_ sender: Any) {
        //var text: String = urlToFetch.text!
        /*let t=urlToFetch.text?{
            
        }*/
        //let API_URL = "http://pastebin.com/raw/wgkJgazE"
        FileCacher.displayImageGrid(vc: self, API_URL: urlToFetch.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //FileCacher.cacheAndShowImage(url: "https://www.cine-feuilles.ch/storage/app/uploads/public/5a3/b98/553/5a3b98553b35a721674405.jpg", uiImageView: uiImageView)
        //FileCacher.cacheAndShowImage(<#T##FileCacher#>)
        uiImageView.layer.borderWidth=0.5
        uiImageView.layer.borderColor=UIColor(red:0/255, green:0/255, blue:227/255, alpha: 1).cgColor
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
