//
//  Cheese.swift
//  Mouse racing
//
//  Created by Артем Галиев on 14.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import SpriteKit

class Cheese: SKSpriteNode {
    private static let buttonName = SenderButtonName()
    static func createCheese(atY posY: CGFloat) -> SKSpriteNode {

        let cheese = SKSpriteNode(imageNamed: "cheese")
        cheese.xScale = 1.2
        cheese.yScale = 1.2
        cheese.position.x = locationGenerationForCheese()
        cheese.position.y = posY
        cheese.zPosition = 1
        cheese.name = buttonName.cheese
        
        cheese.physicsBody = SKPhysicsBody(circleOfRadius: cheese.size.width / 3)
        cheese.physicsBody?.categoryBitMask = BitMaskCategory.cheeseCategory
        cheese.physicsBody?.collisionBitMask = BitMaskCategory.none
        cheese.physicsBody?.contactTestBitMask = BitMaskCategory.mouseCategory
        
        return cheese
    }

    
    static func locationGenerationForCheese() -> CGFloat {
        let randomInt = Int.random(in: 1...3)
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
