//
//  Trap.swift
//  Mouse racing
//
//  Created by Артем Галиев on 14.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import SpriteKit

class Trap: SKSpriteNode {
    private static let buttonName = SenderButtonName()
    static func createTrap(atY posY: CGFloat) -> SKSpriteNode {

        
        let trap = SKSpriteNode(imageNamed: "trap")
        trap.xScale = 2.1
        trap.yScale = 2.1
        trap.position.x = locationGenerationForTrap()
        trap.position.y = posY
        trap.zPosition = 1
        trap.name = buttonName.trap
        
        trap.physicsBody = SKPhysicsBody(circleOfRadius: trap.size.width / 7)
        trap.physicsBody?.categoryBitMask = BitMaskCategory.trapCategory
        trap.physicsBody?.collisionBitMask = BitMaskCategory.mouseCategory
        trap.physicsBody?.contactTestBitMask = BitMaskCategory.mouseCategory

        return trap
    }
    
    static var randomRepeat = 0
    
    static func locationGenerationForTrap() -> CGFloat {
        var randomInt = Int.random(in: 1...3)
        while randomRepeat == randomInt {
            randomInt = Int.random(in: 1...3)
        }
        randomRepeat = randomInt
        var posX: CGFloat = 0
        switch randomInt {
        case 1: posX = CGFloat(187.5)
        case 2: posX = CGFloat(0)
        case 3: posX = CGFloat(-187.5)
        default:
            print("error locationGenerationForTrap")
        }
        return posX
    }
}

