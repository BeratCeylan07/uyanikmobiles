//
//  ViewController.swift
//  WebViewDemo
//
//

import UIKit
import WebKit
import SwiftUI

class ViewController: UIViewController, WKScriptMessageHandler {
    
    var webView: WKWebView!
    var button: UIButton!
    var resultLabel: UILabel!
    var isLoading = true;
        
    override func viewDidLoad() {
        super.viewDidLoad()


        // Add a default handler to serve static files (i.e. anything other than HTML files)

        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        if(isLoading == true){

        }else{
            
        }
        // Do any additional setup after loading the view.
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *){
            configuration.requiresUserActionForMediaPlayback = false
        }else{
            configuration.mediaPlaybackRequiresUserAction = false
        }
        let contentController = WKUserContentController()
        contentController.add(self,name: "onScanned")
        contentController.add(self,name: "close")
        configuration.userContentController = contentController
        
        //create the webView with the custom configuration.
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        

        

        self.view.addSubview(self.webView)
        
        self.webView.isHidden = false
        
        
        let url = URL(string:"https://google.com")
        let request = URLRequest(url: url!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            let myURL = UserDefaults.standard.string(forKey: "adminLink")
            self.isLoading = false
    
            self.webView.load(URLRequest(url: URL(string: myURL ?? "http://uyaniksistem.online/AdminAuth/Index")!))
        }
        //if let indexURL = Bundle.main.url(forResource: "scanner",
        //                                  withExtension: "html", subdirectory: "www") {
        //    self.webView.loadFileURL(indexURL,
        //                             allowingReadAccessTo: indexURL)
        //}
    }
    
    
 
    
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let webView = self.webView {
            let insets = view.safeAreaInsets
            let width: CGFloat = view.frame.width
            let x = view.frame.width - insets.right - width
            let y = insets.top
            let height = view.frame.height - insets.top - insets.bottom
            webView.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
       
    }
    
    @objc func applicationWillResignActive(notification: NSNotification){
        print("entering background")
        self.webView.evaluateJavaScript("stopScan();")
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        print("back active")
        if self.webView.isHidden == false {
            print("Scanner is on, start scan")
            self.webView.evaluateJavaScript("startScan();")
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "onScanned" {
            self.webView.isHidden = true
            print("JavaScript is sending a message \(message.body)")
        } else if message.name == "close" {
            self.webView.isHidden = true
        }
    }
}

