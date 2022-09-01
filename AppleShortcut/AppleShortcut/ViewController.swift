//
//  ViewController.swift
//  AppleShortcut
//
//  Created by Tolga Taner on 1.09.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var generatorButton: UIButton!
    
    private let renderer: LocalServerProtocol & HTMLRendererProtocol = HTMLRenderer()
    
    deinit {
        renderer.stopServer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func generatorButtonDidTapped(_ sender: Any) {
        renderer.start(andEmbed: "shortcut://product?productId=12345")
    }
    


}

