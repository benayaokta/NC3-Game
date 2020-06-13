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
    var changeTool: SKSpriteNode!
    var respawn: SKAction!
    var labelCounterNyamuk: SKLabelNode!{
        didSet{
            labelCounterNyamuk.text = "\(counter)"
        }
    }
    var counter = 0
    
    override func didMove(to view: SKView) {
        
        //MARK -> PENTING
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 7, y: 540, width: 824, height: 1130))
        
        tool = (childNode(withName: "tool") as! SKSpriteNode)
        tool.physicsBody?.categoryBitMask = PhysicsCategory.tool
        tool.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        print(tool.position)
        
        labelCounterNyamuk = self.childNode(withName: "counter") as? SKLabelNode
        
        changeTool = childNode(withName: "changeTool") as? SKSpriteNode
        
        //spawn nyamuk
        let generateNyamuk = SKAction.run {
            self.spawnNyamuk()
        }
        let generateMany = SKAction.repeat(generateNyamuk, count: 5)
        
        let delay = SKAction.wait(forDuration: 3)
        
        //looping nyamuk
//        let respawn = run(SKAction.sequence([generateMany]),withKey: "spawnNyamuk")
        respawn = SKAction.sequence([delay, generateMany])
        
//        run(SKAction.repeatForever(SKAction.sequence([generateMany, delay])),withKey: "spawnNyamuk")
        run(respawn, withKey: "respawnNyamuk")
        
    }
    
    func spawnNyamuk(){
        //buat sprite node isinya texture nyamuk
        nyamuk = SKSpriteNode(imageNamed: "mosquito-1")
        nyamuk.name = "nyamuk"
        nyamuk.size = CGSize(width: 100, height: 100)
        
        //atur posisi
        let randomXDistribution = GKRandomDistribution(lowestValue: 10, highestValue: 810)
        let xPosition = CGFloat(randomXDistribution.nextInt())
        
        let randomYDistribution = GKRandomDistribution(lowestValue: 550, highestValue: 1120)
        let yPosition = CGFloat(randomYDistribution.nextInt())
        nyamuk.zPosition = 2
        nyamuk.position = CGPoint(x: xPosition, y: yPosition)
        
        //animasi gerak2
        let moveNyamuk = SKAction.moveBy(x: 500, y: 200, duration: 1)
        //        if nyamuk.position.y > 1130 {
        //            nyamuk.position.y = nyamuk.position(SKAction.moveBy(x: 0, y: -600, duration: 2)
        //        }
        //        let completeAction = SKAction.sequence([moveNyamuk, SKAction.removeFromParent()])
        let completeMovement = SKAction.sequence([moveNyamuk, moveNyamuk.reversed()])
        let completeAction = SKAction.repeatForever(completeMovement)
        
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
        labelCounterNyamuk.text = "\(counter)"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode{
            switch node {
            case tool:
                print("ok")
            case changeTool:
                print("changed")
            default:
                let location = touch.location(in: self)
                tool.position.x = location.x
                tool.position.y = location.y
                print(tool.position)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tool.position = CGPoint(x: 414, y: 300)
    }
    
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let bitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if bitMask == PhysicsCategory.nyamuk | PhysicsCategory.tool{
            counter += 1
            print(counter)
            var node: SKNode? = nil
            if contact.bodyA.node?.name == "nyamuk" {
                node = contact.bodyA.node
            }else{
                node = contact.bodyB.node
            }
            node!.physicsBody?.categoryBitMask = 0
            node!.run(SKAction.removeFromParent())

            self.run(respawn, withKey: "respawnNyamuk")
            
        }
    }
}
