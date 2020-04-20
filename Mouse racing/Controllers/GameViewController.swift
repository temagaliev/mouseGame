//
//  GameViewController.swift
//  Mouse racing
//
//  Created by Артем Галиев on 14.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {
    

    @IBOutlet weak var privacyPolicy: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "MenuScene") {
                scene.scaleMode = .fill
                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true

        }
        notifHiddenButton()
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    func notifHiddenButton() {
        NotificationCenter.default.addObserver(self, selector: #selector(hideButton), name: NSNotification.Name(rawValue: "off"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showButton), name: NSNotification.Name(rawValue: "on"), object: nil)

    }
    @objc func hideButton() {
        privacyPolicy.isHidden = true
    }
    
    @objc func showButton() {
        privacyPolicy.isHidden = false
    }

}
