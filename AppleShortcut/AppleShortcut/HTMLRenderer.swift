//
//  HTMLRenderer.swift
//  Shortcut
//
//  Created by Tolga Taner on 1.09.2022.
//

import UIKit.UIApplication
import Swifter

protocol Renderer {
    func render()
}

protocol HTMLRendererProtocol: Renderer {
    func adjustHTML(withTitle title: String, withDeeplink link: URL) -> String
    func start(andEmbed deeplink: String)
}

protocol LocalServerProtocol {
    var server: HttpServer? { get set }
    var port: in_port_t { get }
    var localServerUrl: URL? { get }
    
    func stopServer()
    func startServer()
}

final class HTMLRenderer {
    var server: HttpServer?
}

extension HTMLRenderer: LocalServerProtocol {
    
    var port: in_port_t { 8083 }
    
    var localServerUrl: URL? { URL(string: "http://localhost:8083/deeplink") }
    
    func stopServer() {
        server?.stop()
    }
    
    func startServer() {
        try? server?.start(port)
    }
    
}
extension HTMLRenderer: HTMLRendererProtocol {
    
    func start(andEmbed deeplink: String) {
        guard let deeplink: URL = URL(string: deeplink) else { return }
        let html = adjustHTML(withTitle: "Shortcut", withDeeplink: deeplink)
        guard let base64 = html.data(using: .utf8)?.base64EncodedString() else { return }
        server = HttpServer()
        server?["/deeplink"] = { request in .movedPermanently("data:text/html;base64,\(base64)") }
        startServer()
        render()
    }
    
    func adjustHTML(withTitle title: String, withDeeplink link: URL) -> String {
                """
                <html>
                <head>
                <title>\(title)</title>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
                <meta name="apple-mobile-web-app-capable" content="yes">
                <meta name="apple-mobile-web-app-status-bar-style" content="#ffffff">
                <meta name="apple-mobile-web-app-title" content="\(title)">
                </head>
                <body>
                <a id="redirect" href="\(link.absoluteString)"></a>
                </body>
                </html>
                <script type="text/javascript">
                    if (window.navigator.standalone) {
                        var element = document.getElementById('redirect');
                        var event = document.createEvent('MouseEvents');
                        event.initEvent('click', true, true, document.defaultView, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
                        setTimeout(function() { element.dispatchEvent(event); }, 25);
                    } else {
                        var p = document.createElement('p');
                        var node = document.createTextNode('Click Share Button and then Add to Home Screen');
                        p.appendChild(node);
                        document.body.appendChild(p);
                    }
                </script>
        """
    }
    
    func render() {
        guard let localServerUrl = localServerUrl else { return }
        UIApplication.shared.open(localServerUrl)
    }
}
