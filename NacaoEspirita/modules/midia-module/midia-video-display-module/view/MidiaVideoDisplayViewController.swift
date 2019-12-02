//
//  MidiaVideoDisplayViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import WebKit

class MidiaVideoDisplayViewController: UIViewController, WKNavigationDelegate {
    
    var presenter: MidiaVideoDisplayViewToPresenterProtocol?
    
    var webView: WKWebView!
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setWebView()
    }
    
    func setWebView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        let url = URL(string: self.url)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

//MARK: Interaction between Presenter and View
extension MidiaVideoDisplayViewController: MidiaVideoDisplayPresenterToViewProtocol {

}
