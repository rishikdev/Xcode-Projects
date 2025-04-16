//
//  WebView.swift
//  PizzaApp
//
//  Created by Rishik Dev on 02/05/23.
//

import SwiftUI
import WebKit

struct WebView: View {
    @State private var showWebViewSheet: Bool = false
    
    private static let url = URL(string: "https://rishikdev.github.io/")!
    private static let urlRequest = URLRequest(url: url)
    private let webViewHelper = WebViewHelper(webView: nil, urlRequest: urlRequest)
    
    var body: some View {
        VStack {
            HStack {
                Link(destination: WebView.url) { Text("Open Externally") }
                Spacer()
                Button("Open Modally") { showWebViewSheet.toggle() }
            }
            .buttonStyle(.bordered)
            .tint(.blue)
            .padding([.horizontal, .top])
            
            WebViewFull(webViewHelper: webViewHelper, url: WebView.url)
        }
        .sheet(isPresented: $showWebViewSheet) {
            WebViewFull(webViewHelper: webViewHelper, url: WebView.url)
        }
        .frame(maxWidth: .infinity, minHeight: 400)
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(radius: 2, x: 2, y: 2)
        .padding(5)
    }
}

private struct WebViewFull: View {
    var webViewHelper: WebViewHelper
    var url: URL
    
    var body: some View {
        VStack {
            webViewHelper
                .cornerRadius(10)
            
            HStack {
                Button {
                    webViewHelper.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Button {
                    webViewHelper.goForward()
                } label: {
                    Image(systemName: "chevron.right")
                }
                
                Spacer()                
            }
            .buttonStyle(.bordered)
            .tint(.blue)
            .padding(4)
        }
        .padding()
    }
}

private struct WebViewHelper: UIViewRepresentable {
    var webView: WKWebView?
    var urlRequest: URLRequest
    
    init(webView: WKWebView?, urlRequest: URLRequest) {
        self.webView = WKWebView()
        self.urlRequest = urlRequest
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView!
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(urlRequest)
    }
    
    func goBack() {
        webView!.goBack()
    }
    
    func goForward() {
        webView!.goForward()
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}
