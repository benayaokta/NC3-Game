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
    var nyamuk: SKSpriteNode!
    var nyamukDirection: CGFloat = 0
    
    //    var labelCounterNyamuk: SKLabelNode?
    //    var counter = 0
    //
    //    var arrayNode: [SKNode]? = nil
    
    override func didMove(to view: SKView) {
        
        //MARK -> PENTING
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 7, y: 540, width: 824, height: 1130))
        
        tool = (childNode(withName: "tool") as! SKSpriteNode)
        tool.physicsBody?.categoryBitMask = PhysicsCategory.tool
        tool.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        print(tool.position)
        
        //spawn nyamuk
        let generateNyamuk = SKAction.run {
            self.spawnNyamuk()
        }
        let generateMany = SKAction.repeat(generateNyamuk, count: 5)
        
        let delay = SKAction.wait(forDuration: 4)
        
        //looping nyamuk
        run(SKAction.repeatForever(SKAction.sequence([generateMany, delay])),withKey: "spawnNyamuk")
        
    }
    
    func spawnNyamuk(){
        //buat sprite node isinya texture nyamuk
        nyamuk = SKSpriteNode(imageNamed: "mosquito-1")
        nyamuk.name = "nyamuk"
        nyamuk.size = CGSize(width: 100, height: 100)
        
        //atur posisi
        let xPosition = CGFloat.random(in: 10...810)
        let yPosition = CGFloat.random(in: 500...1120)
        nyamuk.zPosition = 2
        nyamuk.position = CGPoint(x: xPosition, y: yPosition)
        
        //animasi gerak2
        let moveNyamuk = SKAction.moveBy(x: 0, y: 600, duration: 4)
        //        if nyamuk.position.y > 1130 {
        //            nyamuk.position.y = nyamuk.position(SKAction.moveBy(x: 0, y: -600, duration: 2)
        //        }
        let completeAction = SKAction.sequence([moveNyamuk, SKAction.removeFromParent()])
        
        //physics body
        let physicsBodyNyamuk = SKPhysicsBody(circleOfRadius: 50)
        physicsBodyNyamuk.categoryBitMask = PhysicsCategory.nyamuk
        physicsBodyNyamuk.contactTestBitMask = PhysicsCategory.tool
        //buat dia terbang
        physicsBodyNyamuk.affectedByGravity = false
        nyamuk.physicsBody = physicsBodyNyamuk
        
        self.addChild(nyamuk)
        
        //set suara
        //action
        //        nyamuk.run(SKAction.group([completeAction]))
        nyamuk.run(completeAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
//        if nyamuk.position.y > 1130 {
//            nyamuk.position.y = SKAction.moveBy(x: 0, y: -400, duration: 3)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        tool.position = position
        print(tool.position)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tool.position = CGPoint(x: 414, y: 300)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            tool.position.x = location.x
            tool.position.y = location.y
            print(tool.position)
        }
    }
}



extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let bitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if bitMask == PhysicsCategory.nyamuk | PhysicsCategory.tool{
            var node: SKNode? = nil
            if contact.bodyA.node?.name == "nyamuk" {
                node = contact.bodyA.node
            }else{
                node = contact.bodyB.node
            }
            
            //            arrayNode?.append(node!)
            //            print(arrayNode?.count)
            node!.run(SKAction.removeFromParent())
            
        }
    }
}
