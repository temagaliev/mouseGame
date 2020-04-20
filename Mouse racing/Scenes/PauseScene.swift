//
//  PauseScene.swift
//  Mouse racing
//
//  Created by Артем Галиев on 15.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import SpriteKit
import GameplayKit

class PauseScene: SKScene {
    
    let sceneManager = SceneManager.shared
    private let buttonName = SenderButtonName()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = #colorLiteral(red: 0.995080173, green: 0.7363654971, blue: 0, alpha: 1)
        
        let nameLabel = SKLabelNode(text: "Pause Game")
        nameLabel.position = CGPoint(x: frame.midX, y: frame.maxY / 2)
        nameLabel.zPosition = 30
        nameLabel.fontSize = 80
        nameLabel.fontName =  "AmericanTypewriter-Bold"
        self.addChild(nameLabel)
        
        let menuTexture = SKTexture(imageNamed: "menuButton")
        let menuButton = SKSpriteNode(texture: menuTexture)
        menuButton.position = CGPoint(x: frame.midX, y: frame.midY)
        menuButton.name = buttonName.menu
        menuButton.zPosition = 30
        self.addChild(menuButton)
        
        let backGameTexture = SKTexture(imageNamed: "backGame")
        let backGameButton = SKSpriteNode(texture: backGameTexture)
        backGameButton.xScale = 5
        backGameButton.yScale = 5
        backGameButton.position = CGPoint(x: frame.midX + backGameButton.size.width + 30, y: frame.minY + backGameButton.size.height * 2)
        backGameButton.name = buttonName.backGame
        backGameButton.zPosition = 30
        self.addChild(backGameButton)
        
        let newStartTexture = SKTexture(imageNamed: "newStart")
        let newStartButton = SKSpriteNode(texture: newStartTexture)
        newStartButton.xScale = 5
        newStartButton.yScale = 5
        newStartButton.position = CGPoint(x: frame.midX - newStartButton.size.width - 30, y: frame.minY + newStartButton.size.height * 2)
        newStartButton.name = buttonName.restart
        newStartButton.zPosition = 30
        self.addChild(newStartButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let node = self.atPoint(touchLocation)
            switch node.name {
            case buttonName.restart:
                sceneManager.gameScene = nil
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let scene = GameScene(fileNamed: "GameScene")
                scene!.scaleMode = .fill
                self.scene!.view?.presentScene(scene!,transition: transition)
            case buttonName.backGame:
                let transition = SKTransition.crossFade(withDuration: 1.0)
                guard let scene = sceneManager.gameScene else { return }
                scene.scaleMode = .fill
                self.scene!.view?.presentScene(scene,transition: transition)
            case buttonName.menu:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "on"), object: nil)
                sceneManager.gameScene = nil 
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                let scene = MenuScene(fileNamed: "MenuScene")
                scene!.scaleMode = .fill
                self.scene!.view?.presentScene(scene!,transition: transition)
            default:
                print("error in pause button scene")
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let gameScene = sceneManager.gameScene {
            if !gameScene.isPaused {
                gameScene.isPaused = true 
            }
        }
    }
}
