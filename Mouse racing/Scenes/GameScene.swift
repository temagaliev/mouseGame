//
//  GameScene.swift
//  Mouse racing
//
//  Created by Артем Галиев on 14.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let sceneManager = SceneManager.shared
    let userDefaults = UserDefaults.standard
    private let buttonName = SenderButtonName()
    
    //MARK: - SKNode
    private let healthBackgraund = SKSpriteNode(imageNamed: "health")
    private let healthLabel = SKLabelNode(text: "5")
    private let cheeseBackgraund = SKSpriteNode(imageNamed: "cheese")
    private let cheeseLabel = SKLabelNode(text: "0")
    private let scoreLabel = SKLabelNode(text: "Очки: 0")
    private var floor: SKSpriteNode!
    private var mousePlayer: SKSpriteNode!
    private var pauseButton: SKSpriteNode!
    
    //MARK: - Varible
    private var moveStartMouse: CGFloat = 0
    private var moveEndMouse: CGFloat = 0
    
    private var speedPlayer: Double = 4
    
    private var score: Int = 0
    private var cheese: Int = 0
    private var health: Int = 5
    private var gameOverBool: Bool = false
    private var isSound: Bool = true
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        self.scene?.isPaused = false 
        guard sceneManager.gameScene == nil else { return }
        
        if let soundValue = userDefaults.object(forKey: "isSound") {
            let sound = soundValue as! Bool
            isSound = sound
        }
        
        if isSound {
            self.run(SKAction.playSoundFileNamed("cheeseSound", waitForCompletion: false))
            self.run(SKAction.playSoundFileNamed("trapSound", waitForCompletion: false))
        }
        physicsWorld.contactDelegate = self
        
        //Позиция для мышки и ловушек
        let mousePostion = CGPoint(x: frame.midX, y: frame.midY - 300)
        let backgroundPosition = CGSize(width: frame.maxX * 2, height: frame.maxY * 2)
        
        //Создание мышки и ловушек
        floor = Backgraund.createBackgraund(at: backgroundPosition)
        mousePlayer = Mouse.createMouse(at: mousePostion)
        
        //Создание показателей и кнопок
        configureUI()
        
        addChild(floor)
        addChild(mousePlayer)
        
        //Создание ловушек и сыра
        addTrap()
        addCheese()
        
    }
    
    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            moveStartMouse = touchLocation.x
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let node = self.atPoint(touchLocation)
                
                //Нажатие на паузу
                if node.name == buttonName.pauseButton {
                    let transition = SKTransition.crossFade(withDuration: 1.0)
                    let pauseScene = PauseScene(fileNamed: "PauseScene")
                    pauseScene!.scaleMode = .fill
                    gameOverBool = false
                    userDefaults.set(gameOverBool, forKey: "gameOverBool")
                    sceneManager.gameScene = self
                    self.scene?.isPaused = true
                    self.scene!.view?.presentScene(pauseScene!,transition: transition)
                }
            }
        }
    }
    
    //MARK: - touchesEnded
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            moveEndMouse = touchLocation.x
            
            //Обработка движения мышки
            Mouse.mouseDirection(startLocation: moveStartMouse, endLocation: moveEndMouse, currentLocation: self.mousePlayer.position.x) { (newLocation) in
                let moveLocation = SKAction.move(to: CGPoint(x: newLocation, y: self.frame.midY - 300), duration: 0.08)
                self.mousePlayer.run(moveLocation)
            }
        }
    }
    
    //MARK: - didSimulatePhysics
    override func didSimulatePhysics() {
        //Удаление ловушек
        enumerateChildNodes(withName: buttonName.trap) { (trap, stop) in
            let hightScreen = UIScreen.main.bounds.height
            if trap.position.y < -hightScreen  {
                trap.removeFromParent()
                
                self.score = self.score + 1
                self.scoreLabel.text =  "Очки:" + String(self.score)
                
                //Ускорение игры
                switch self.score {
                case 15: self.speedPlayer = 3.8
                case 35: self.speedPlayer = 3.5
                case 55: self.speedPlayer = 3
                case 80: self.speedPlayer = 2.5
                case 100: self.speedPlayer = 2.0
                default:
                    print("error in speed player")
                }
            }
        }
        
        //Удаление сыра
        enumerateChildNodes(withName: buttonName.cheese) { (cheese, stop) in
            let hightScreen = UIScreen.main.bounds.height
            if cheese.position.y < -hightScreen  {
                cheese.removeFromParent()
            }
        }
    }
    
    //MARK: - Добавление сыра и ловушек
    private func addCheese() {
        let cheeseCreate = SKAction.run {
            let cheese = Cheese.createCheese(atY: self.frame.maxY + 10)
            let move = SKAction.moveTo(y: self.frame.minY - 10, duration: self.speedPlayer)
            cheese.run(move)
            self.addChild(cheese)
            
        }
        let cheeseCrationDelay = SKAction.wait(forDuration: 5, withRange: 0.5)
        let cheeseSequence = SKAction.sequence([cheeseCreate, cheeseCrationDelay])
        let cheeseRunAction = SKAction.repeatForever(cheeseSequence)
        
        run(cheeseRunAction)
    }
    
    private func addTrap() {
        let trapCreate = SKAction.run {
            let trap = Trap.createTrap(atY: self.frame.maxY + 10)
            let move = SKAction.moveTo(y: self.frame.minY - 10, duration: self.speedPlayer)
            trap.run(move)
            self.addChild(trap)
            
        }

        let trapCrationDelay = SKAction.wait(forDuration: 0.7)
        let trapSequence = SKAction.sequence([trapCreate, trapCrationDelay])
        let trapRunAction = SKAction.repeatForever(trapSequence)
        
        run(trapRunAction)
    }
    
    //MARK: - Создание показателей
    private func configureUI() {
        // Количество сыра картинка
        cheeseBackgraund.position = CGPoint(x: frame.maxX - cheeseBackgraund.size.width, y: frame.maxY - cheeseBackgraund.size.height - healthBackgraund.size.height - healthBackgraund.size.height - 120)
        cheeseBackgraund.zPosition = 99
        addChild(cheeseBackgraund)
        
        // Количество сыра число
        cheeseLabel.horizontalAlignmentMode = .center
        cheeseLabel.verticalAlignmentMode = .center
        cheeseLabel.position = CGPoint(x: 1, y: 1)
        cheeseLabel.zPosition = 100
        cheeseLabel.fontSize = 25
        cheeseLabel.fontName = "AmericanTypewriter-Bold"
        cheeseLabel.fontColor = .darkGray
        cheeseBackgraund.addChild(cheeseLabel)
        
        //Жизни картинка
        healthBackgraund.position = CGPoint(x: frame.maxX - cheeseBackgraund.size.width, y: frame.maxY - cheeseBackgraund.size.height - healthBackgraund.size.height - 70)
        healthBackgraund.zPosition = 99
        addChild(healthBackgraund)
        
        //Жизни количесво
        healthLabel.horizontalAlignmentMode = .center
        healthLabel.verticalAlignmentMode = .center
        healthLabel.position = CGPoint(x: 1, y: 1)
        healthLabel.zPosition = 100
        healthLabel.fontSize = 25
        healthLabel.fontName = "AmericanTypewriter-Bold"
        healthLabel.fontColor = .white
        healthBackgraund.addChild(healthLabel)
        
        //Очки
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: frame.maxX - cheeseBackgraund.size.width, y: frame.maxY - cheeseBackgraund.size.height - 10)
        scoreLabel.zPosition = 100
        scoreLabel.fontSize = 25
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontColor = .white
        addChild(scoreLabel)
        
        //pauseButton
        let pauseTexture = SKTexture(imageNamed: "pause")
        pauseButton = SKSpriteNode(texture: pauseTexture)
        pauseButton.xScale = 1.5
        pauseButton.yScale = 1.5
        pauseButton.position = CGPoint(x: frame.minX + pauseButton.size.width - 30, y: frame.maxY - cheeseBackgraund.size.height - 10)
        pauseButton.name = buttonName.pauseButton
        pauseButton.zPosition = 100
        self.addChild(pauseButton)
    }
    
    //Обработка конца игры
    private func gameOver() {
        if health == 0 {
            self.scene?.isPaused = true
            gameOverBool = true
            userDefaults.set(cheese, forKey: "cheeseUD")
            userDefaults.set(score, forKey: "scoreUD")
            userDefaults.set(gameOverBool, forKey: "gameOverBool")
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
            let scene = GameOverScene(fileNamed: "GameOverScene")
            scene!.scaleMode = .fill
            gameOverBool = false
            self.scene!.view?.presentScene(scene!,transition: transition)
        }
    }
    
}

//MARK: - extension SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        //Эффекты
        let cheeseExplosion = SKEmitterNode(fileNamed: "CheeseParticle")
        let trapExplosion = SKEmitterNode(fileNamed: "TrapParticle")
        
        let contactPoint = contact.contactPoint
        trapExplosion?.position = contactPoint
        cheeseExplosion?.position = contactPoint
        let waitForExplsionAction = SKAction.wait(forDuration: 1.0)
        
        //Переменные контакта
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        let mouse = BitMaskCategory.mouseCategory
        let cheese = BitMaskCategory.cheeseCategory
        let trap = BitMaskCategory.trapCategory
        
        //Обработка контакта
        if bodyA == mouse && bodyB == trap || bodyB == mouse && bodyA == trap {
            if contact.bodyA.node?.name == "trap" {
                contact.bodyA.node?.removeFromParent()
                if self.health != 0 {
                    self.health = self.health - 1
                }
                self.healthLabel.text = String(self.health)
                self.run(SKAction.playSoundFileNamed("trapSound", waitForCompletion: false))
                self.gameOver()
            } else {
                contact.bodyB.node?.removeFromParent()
                if self.health != 0 {
                    self.health = self.health - 1
                }
                self.healthLabel.text = String(self.health)
                if isSound {
                    self.run(SKAction.playSoundFileNamed("trapSound", waitForCompletion: false))
                }
                self.gameOver()
            }
            addChild(trapExplosion!)
            self.run(waitForExplsionAction, completion: {
                trapExplosion?.removeFromParent()
            })
        } else if bodyA == mouse && bodyB == cheese || bodyB == mouse && bodyA == cheese {
            if contact.bodyA.node?.name == "cheese" {
                contact.bodyA.node?.removeFromParent()
                self.cheese = self.cheese + 1
                self.cheeseLabel.text = String(self.cheese)
                self.run(SKAction.playSoundFileNamed("cheeseSound", waitForCompletion: false))
            } else {
                contact.bodyB.node?.removeFromParent()
                self.cheese = self.cheese + 1
                self.cheeseLabel.text = String(self.cheese)
                if isSound {
                    self.run(SKAction.playSoundFileNamed("cheeseSound", waitForCompletion: false))
                }
            }
            addChild(cheeseExplosion!)
            self.run(waitForExplsionAction, completion: {
                cheeseExplosion?.removeFromParent()
            })
        }
        
    }
    
}
