//
//  ViewController.swift
//  Shared (App)
//
//  Created by Rishik Dev on 22/08/23.
//

import WebKit
import SwiftUI

#if os(iOS)
import UIKit
typealias PlatformViewController = UIViewController
#elseif os(macOS)
import Cocoa
import SafariServices
typealias PlatformViewController = NSViewController
#endif

let extensionBundleIdentifier = "com.rishikdev.RYTD.Extension"

class ViewController: PlatformViewController, WKNavigationDelegate, WKScriptMessageHandler {

    @IBOutlet var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self

#if os(iOS)
        self.webView.scrollView.isScrollEnabled = true
        self.webView.layer.cornerRadius = 5
        self.webView.isOpaque = false
#elseif os(macOS)
        self.webView.layer?.cornerRadius = 5
#endif
        self.webView.configuration.userContentController.add(self, name: "controller")

        self.webView.loadFileURL(Bundle.main.url(forResource: "Main", withExtension: "html")!, allowingReadAccessTo: Bundle.main.resourceURL!)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
#if os(iOS)
        webView.evaluateJavaScript("show('ios')")
#elseif os(macOS)
        webView.evaluateJavaScript("show('mac')")

        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                if #available(macOS 13, *) {
                    webView.evaluateJavaScript("show('mac', \(state.isEnabled), true)")
                } else {
                    webView.evaluateJavaScript("show('mac', \(state.isEnabled), false)")
                }
            }
        }
#endif
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
#if os(macOS)
        if (message.body as! String != "open-preferences") {
            return;
        }

        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
            guard error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                NSApplication.shared.terminate(nil)
            }
        }
#endif
    }

}

#if os(iOS)
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "ViewController") as? ViewController
        
        return vc!
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

#Preview {
    ViewControllerRepresentable()
}

#elseif os(macOS)
struct ViewControllerRepresentable: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> NSViewController {
        let vc = NSStoryboard(name: "Main", bundle: .main).instantiateController(withIdentifier: "ViewController") as? ViewController
        
        return vc!
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        
    }
}

#Preview {
    ViewControllerRepresentable()
}
#endif
