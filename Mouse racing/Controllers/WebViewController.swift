//
//  WebViewController.swift
//  Mouse racing
//
//  Created by Артем Галиев on 16.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private var polCondURL = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        //Проверка страны телефона
        polCondURL = PrivacyPolicyManager.checkLocateYouDevice()
        
        guard let url = URL(string: polCondURL) else { return }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        
        
    }
    
    //Сохранение куки
    private func saveCookies() {
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            return
        }
        let array = cookies.compactMap { (cookie) -> [HTTPCookiePropertyKey: Any]? in
            cookie.properties
        }
        UserDefaults.standard.set(array, forKey: "cookies")
        UserDefaults.standard.synchronize()
    }
    
    //Загрузка куки
    private func loadCookies() {
        guard let cookies = UserDefaults.standard.value(forKey: "cookies") as? [[HTTPCookiePropertyKey: Any]] else {
            return
        }
        cookies.forEach { (cookie) in
            guard let cookie = HTTPCookie.init(properties: cookie) else {
                return
            }
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
    
}

//MARK: - UIWebViewDelegate
extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadCookies()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        saveCookies()
    }
}


