//
//  Mouse.swift
//  Mouse racing
//
//  Created by Артем Галиев on 14.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import SpriteKit

class Mouse: SKSpriteNode {
    static func createMouse(at point: CGPoint) -> SKSpriteNode {
        
        let mouse = SKSpriteNode(imageNamed: "mouse")
        mouse.position = point
        mouse.xScale = 1.4
        mouse.yScale = 1.4
        mouse.zPosition = 1
        
        mouse.physicsBody = SKPhysicsBody(circleOfRadius: mouse.size.width / 3)
        mouse.physicsBody?.isDynamic = false
        mouse.physicsBody?.categoryBitMask = BitMaskCategory.mouseCategory
        mouse.physicsBody?.collisionBitMask = BitMaskCategory.trapCategory
        mouse.physicsBody?.collisionBitMask = BitMaskCategory.cheeseCategory
        mouse.physicsBody?.contactTestBitMask = BitMaskCategory.trapCategory
        mouse.physicsBody?.contactTestBitMask = BitMaskCategory.cheeseCategory
        
        return mouse
    }
    
    static func mouseDirection(startLocation: CGFloat, endLocation: CGFloat, currentLocation: CGFloat, completion: @escaping (_ moveLocation: CGFloat) -> Void) {
        switch startLocation > endLocation {
        case true:
            switch Int(currentLocation) {
            case 187:
                completion(CGFloat(0))
            case 0: completion(CGFloat(-187.5))
            default:
                print("error")
            }

        case false:
            switch Int(currentLocation) {
            case -187: completion(CGFloat(0))
            case 0: completion(CGFloat(187.5))
            default:
                print("error")
            }
        }
    }

}

