//
//  GameOverScene.swift
//  Mouse racing
//
//  Created by Артем Галиев on 15.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    let userDefaults = UserDefaults.standard
    let buttonName = SenderButtonName()
    
    var cheeseLabel = SKLabelNode(text: "Cheese: 0")
    var scoreLabel = SKLabelNode(text: "Score: 0")
    
    override func didMove(to view: SKView) {
        self.backgroundColor = #colorLiteral(red: 0.995080173, green: 0.7363654971, blue: 0, alpha: 1)
        
        let nameLabel = SKLabelNode(text: "Game Over")
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
        
        let newStartTexture = SKTexture(imageNamed: "newStart")
        let newStartButton = SKSpriteNode(texture: newStartTexture)
        newStartButton.xScale = 5
        newStartButton.yScale = 5
        newStartButton.position = CGPoint(x: frame.midX, y: frame.minY + newStartButton.size.height * 2)
        newStartButton.name = buttonName.restart
        newStartButton.zPosition = 30
        self.addChild(newStartButton)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY / 2 - 60)
        scoreLabel.zPosition = 30
        scoreLabel.fontSize = 45
        scoreLabel.fontName =  "AmericanTypewriter-Bold"
        self.addChild(scoreLabel)
        
        cheeseLabel = SKLabelNode(text: "Cheese: 0")
        cheeseLabel.position = CGPoint(x: frame.midX, y: frame.maxY / 2 - 120)
        cheeseLabel.zPosition = 30
        cheeseLabel.fontSize = 45
        cheeseLabel.fontName =  "AmericanTypewriter-Bold"
        self.addChild(cheeseLabel)
        
        currnetValueFromCoreData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let node = self.atPoint(touchLocation)
            switch node.name {
            case buttonName.restart:
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let scene = GameScene(fileNamed: "GameScene")
                scene!.scaleMode = .fill
                self.scene!.view?.presentScene(scene!,transition: transition)
            case buttonName.menu:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "on"), object: nil)
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                let scene = MenuScene(fileNamed: "MenuScene")
                scene!.scaleMode = .fill
                self.scene!.view?.presentScene(scene!,transition: transition)
            default:
                print("error in pause button scene")
            }
        }
    }
    
    private func currnetValueFromCoreData() {
        if let cheeseValue = userDefaults.object(forKey: "cheeseUD") {
            let value = cheeseValue as! Int
            cheeseLabel.text = "Cheese: \(value)"
        }
        
        if let scoreValue = userDefaults.object(forKey: "scoreUD") {
            let value = scoreValue as! Int
            scoreLabel.text = "Score: \(value)"
        }
    }
}
