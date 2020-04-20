//
//  MenuScene.swift
//  Mouse racing
//
//  Created by Артем Галиев on 15.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class MenuScene: SKScene {
    
    private let userDefaults = UserDefaults.standard
    private let buttonName = SenderButtonName()
    private var soundButton: SKSpriteNode!
    
    private var topScoreLabel = SKLabelNode(text: "Hight Score: 0")
    private var cheeseScoreLabel = SKLabelNode(text: "Cheese: 0")
    private var topScore = 0
    private var cheeseCount = 0
    private var isSound: Bool = true
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        self.backgroundColor = #colorLiteral(red: 0.995080173, green: 0.7363654971, blue: 0, alpha: 1)
        
        //ВКЛ/ВЫКЛ Звуков
        if let soundValue = userDefaults.object(forKey: "isSound") {
            let soundBool = soundValue as! Bool
            isSound = soundBool
        }
        
        //Создание кнопки и картинки
        createSKSpriteNodes()
        
        //Создание текста
        topScoreLabel = createSKLabelNode("Hight Score: 0", x: frame.midX, y: frame.midY)
        self.addChild(topScoreLabel)
        
        cheeseScoreLabel = createSKLabelNode("Cheese: 0", x: frame.midX, y: frame.midY - 80)
        self.addChild(cheeseScoreLabel)
        
        //Обработка данных
        newValueFromDataAndCheckOldData()
    }
    
    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let node = self.atPoint(touchLocation)
            switch node.name {
            case buttonName.playButton:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "off"), object: nil)
                userDefaults.set(topScore, forKey: "hightScore")
                userDefaults.set(cheeseCount, forKey: "cheeseScore")
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene!.scaleMode = .fill
                self.scene!.view?.presentScene(gameScene!,transition: transition)
            case buttonName.soundButton:
                switch isSound {
                case true:
                    isSound = !isSound
                    soundButton.texture = SKTexture(imageNamed: "soundOFF")
                    userDefaults.set(isSound, forKey: "isSound")
                case false:
                    isSound = !isSound
                    soundButton.texture = SKTexture(imageNamed: "soundON")
                    userDefaults.set(isSound, forKey: "isSound")
                }
            default:
                print("")
            }
        }
    }
    
    
    //Cоздание текста
    private func createSKLabelNode(_ text: String, x xPosition: CGFloat, y yPosition: CGFloat) -> SKLabelNode {
        let lable = SKLabelNode(text: text)
        lable.position = CGPoint(x: xPosition, y: yPosition)
        lable.fontSize = 45
        lable.fontName = "AmericanTypewriter-Bold"
        lable.zPosition = 30
        return lable
    }
    
    //Создание кнопки и картинки
    private func createSKSpriteNodes() {
        let playTexture = SKTexture(imageNamed: "playButton")
        let playButton = SKSpriteNode(texture: playTexture)
        playButton.position = CGPoint(x: frame.midX, y: frame.minY + playButton.size.height + 30)
        playButton.name = buttonName.playButton
        playButton.zPosition = 30
        self.addChild(playButton)
        
        var nameTexture = "soundON"
        switch isSound {
        case true: nameTexture = "soundON"
        case false: nameTexture = "soundOFF"
        }
        let soundTexture = SKTexture(imageNamed: nameTexture)
        soundButton = SKSpriteNode(texture: soundTexture)
        soundButton.position = CGPoint(x: frame.midX, y: frame.minY + (soundButton.size.height + 20) * 2)
        soundButton.name = buttonName.soundButton
        soundButton.zPosition = 30
        self.addChild(soundButton)
        
        let mouseWithCheese = SKSpriteNode(imageNamed: "mouseWithCheese")
        mouseWithCheese.position = CGPoint(x: frame.midX, y: frame.maxY - mouseWithCheese.size.height - 20)
        mouseWithCheese.zPosition = 30
        self.addChild(mouseWithCheese)
    }
    
    //Получение данных их userDefault
    private func addDataForScoreLabels(completion: @escaping(_ cheeseCompletion: Int,_ scoreCompletion: Int) -> Void) {
        var cheeseResult = 0
        var scoreResult = 0
        if let cheeseValue = userDefaults.object(forKey: "cheeseScore") {
            let cheeseVal = cheeseValue as! Int
            cheeseResult = cheeseVal
        }
        if let scoreValue = userDefaults.object(forKey: "hightScore") {
            let scoreVal = scoreValue as! Int
            scoreResult = scoreVal
        }
        completion(cheeseResult, scoreResult)
    
    }
    
    //Обработка данныз userDefault
    private func newValueFromDataAndCheckOldData() {
        addDataForScoreLabels { (cheeseValue, scoreValue) in
            self.cheeseCount = cheeseValue
            self.topScore = scoreValue
        }
        if let cheeseValue = userDefaults.object(forKey: "cheeseUD") {
            let chValue = cheeseValue as! Int
            if let gameOverBool = userDefaults.object(forKey: "gameOverBool") {
                let boolValue = gameOverBool as! Bool
                if boolValue == true {
                    cheeseCount = cheeseCount + chValue
                }
            }
        }
        
        if let scoreValue = userDefaults.object(forKey: "scoreUD") {
            let curretValue = scoreValue as! Int
            if let gameOverBool = userDefaults.object(forKey: "gameOverBool") {
                let boolValue = gameOverBool as! Bool
                if boolValue == true {
                    if topScore < curretValue {
                        topScore = curretValue
                    }
                }
            }
        }
        
        topScoreLabel.text = "Hight Score: \(topScore)"
        cheeseScoreLabel.text = "Cheese: \(cheeseCount)"
    }

}
