//
//  Backgraund.swift
//  Mouse racing
//
//  Created by Артем Галиев on 14.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import SpriteKit

class Backgraund: SKSpriteNode {
    static func createBackgraund(at size: CGSize) -> SKSpriteNode{
        let floor = SKSpriteNode(imageNamed: "floor")
        floor.size = size
        floor.zPosition = 0
        return floor
    }
}
