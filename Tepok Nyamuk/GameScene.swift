//
//  GameScene.swift
//  Tepok Nyamuk
//
//  Created by Benaya Oktavianus on 09/06/20.
//  Copyright © 2020 -. All rights reserved.
//

import SpriteKit
import GameplayKit


struct PhysicsCategory {
    //cek di kalkulator berapa nilainya
    static let nyamuk: UInt32 = 0b1
    static let tool: UInt32 = 0b101
}

class GameScene: SKScene {
    
    var tool: SKSpriteNode!
    var nyamukDirection: CGFloat = 0
    
    override func didMove(to view: SKView) {
        
        //MARK -> PENTING
        physicsWorld.contactDelegate = self
        
        tool = (childNode(withName: "tool") as! SKSpriteNode)
        tool.physicsBody?.categoryBitMask = PhysicsCategory.tool
        
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
        //buat sprite node isinya texture nyamuk
        let nyamuk = SKSpriteNode(imageNamed: "mosquito-1")
        nyamuk.size = CGSize(width: 100, height: 100)
    
        //atur posisi
        let xPosition = CGFloat.random(in: 400...414) //nanti diubah
        let yPosition = CGFloat.random(in: 650...1600)
        nyamuk.zPosition = 5
        nyamuk.position = CGPoint(x: xPosition, y: yPosition)
        
        //animasi gerak2
        let moveNyamuk = SKAction.moveBy(x: 0, y: -700, duration: 0.7)
        let completeAction = SKAction.sequence([moveNyamuk, SKAction.removeFromParent()])
        
        //physics body
        let physicsBodyNyamuk = SKPhysicsBody(circleOfRadius: 50)
        physicsBodyNyamuk.categoryBitMask = PhysicsCategory.nyamuk
        physicsBodyNyamuk.contactTestBitMask = PhysicsCategory.tool
        nyamuk.physicsBody = physicsBodyNyamuk
        
        self.addChild(nyamuk)
        
        //set suara
        //action
        nyamuk.run(SKAction.group([completeAction]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.spawnNyamuk()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //SKAction.removeFromParent()
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let bitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if bitMask == PhysicsCategory.nyamuk | PhysicsCategory.tool{
            print("ok")
        }
        
    }
    
}


//TESTING
