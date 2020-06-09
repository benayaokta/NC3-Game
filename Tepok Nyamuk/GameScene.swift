//
//  GameScene.swift
//  Tepok Nyamuk
//
//  Created by Benaya Oktavianus on 09/06/20.
//  Copyright © 2020 -. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var tool: SKSpriteNode!
    var nyamukDirection: CGFloat = 0
    
    override func didMove(to view: SKView) {
        tool = (childNode(withName: "tool") as! SKSpriteNode)
        
        //spawn nyamuk
        let generateNyamuk = SKAction.run {
            self.spawnNyamuk()
        }
        let generateMany = SKAction.repeat(generateNyamuk, count: 5)
        
        let delay = SKAction.wait(forDuration: 2)
        
        //looping nyamuk
        run(SKAction.repeatForever(SKAction.sequence([generateMany,delay])))

    }
    
    func spawnNyamuk(){
        //1. buat sprite node isinya texture nyamuk
        let nyamuk = SKSpriteNode(imageNamed: "mosquito-1")
        nyamuk.size = CGSize(width: 100, height: 100)
        self.addChild(nyamuk)
        
        //2. atur posisi
        let xPosition = CGFloat.random(in: 10...818)
        let yPosition = CGFloat.random(in: 650...1600)
        nyamuk.zPosition = 5
        nyamuk.position = CGPoint(x: xPosition, y: yPosition)
        
        //3. animasi gerak2
        let moveNyamuk = SKAction.moveBy(x: 100, y: 300, duration: 0.7)
        let completeAction = SKAction.sequence([moveNyamuk, SKAction.removeFromParent()])
        
        //4. set suara
        
        //5. action
        nyamuk.run(SKAction.group([completeAction]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.spawnNyamuk()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //SKAction.removeFromParent()
    }
    
    
}
