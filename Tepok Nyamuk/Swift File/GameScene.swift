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
    static let nyamuk: UInt32 = 0b1
    static let tool: UInt32 = 0b101
}

class GameScene: SKScene {
    
    var tool: SKSpriteNode!
    var nyamuk: SKSpriteNode!
    var exitNode: SKSpriteNode!
    
    var respawn: SKAction!
    var fly1: SKAction!
    var fly2: SKAction!
    var fly3: SKAction!
    
    var random: Int!
    
    var texture1: [SKTexture] = []
    var texture2: [SKTexture] = []
    var texture3: [SKTexture] = []
    
    var labelCounterNyamuk: SKLabelNode!{
        didSet{
            labelCounterNyamuk.text = "\(counter) Hit"
        }
    }
    var counter = 0
    
    override func didMove(to view: SKView) {
        setupFlyAction()
        
        //MARK -> PENTING
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 7, y: 540, width: 800, height: 1120))
        
        exitNode = (childNode(withName: "exit") as! SKSpriteNode)
        
        tool = (childNode(withName: "tool") as! SKSpriteNode)
        tool.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tool.physicsBody?.categoryBitMask = PhysicsCategory.tool
        
        labelCounterNyamuk = self.childNode(withName: "counter") as? SKLabelNode
        
        //spawn nyamuk
        let generateNyamuk = SKAction.run {
            self.spawnNyamuk()
        }
        let generateMany = SKAction.repeat(generateNyamuk, count: 5)
        let delay = SKAction.wait(forDuration: 2)
        
        //looping nyamuk
        respawn = SKAction.sequence([delay, generateMany])
        run(respawn, withKey: "respawnNyamuk")
    }
    
    func randomNyamuk() -> String {
        random = Int.random(in: 1...3)
        switch random {
        case 1:
            return "nyamuk-standart-1"
        case 2:
            return "nyamuk-kilat-1"
        case 3:
            return "nyamuk-gemuk-1"
        default:
            return " "
        }
    }
    
    func spawnNyamuk(){
        //buat sprite node isinya texture nyamuk
        nyamuk = SKSpriteNode(imageNamed: randomNyamuk())
        nyamuk.name = "nyamuk"
        nyamuk.size = CGSize(width: 165, height: 90)
        
        //atur posisi
        let randomXDistribution = GKRandomDistribution(lowestValue: 10, highestValue: 780)
        let xPosition = CGFloat(randomXDistribution.nextInt())
        
        let randomYDistribution = GKRandomDistribution(lowestValue: 550, highestValue: 1000)
        let yPosition = CGFloat(randomYDistribution.nextInt())
        nyamuk.zPosition = 2
        nyamuk.position = CGPoint(x: xPosition, y: yPosition)
        
        //animasi gerak2
        let moveXNyamuk = SKAction.moveBy(x: CGFloat.random(in: 0...500), y: 0, duration: Double.random(in: 1...3))
        let moveYNyamuk = SKAction.moveBy(x: 0, y: CGFloat.random(in: 200...700), duration: Double.random(in: 1...5))
        let completeXY = SKAction.sequence([moveXNyamuk, moveYNyamuk])
        let completeMovement = SKAction.sequence([completeXY, completeXY.reversed()])
        let completeAction = SKAction.repeatForever(completeMovement)
        
        //physics body
        let physicsBodyNyamuk = SKPhysicsBody(circleOfRadius: 35)
        physicsBodyNyamuk.categoryBitMask = PhysicsCategory.nyamuk
        physicsBodyNyamuk.contactTestBitMask = PhysicsCategory.tool
        
        //buat dia terbang
        physicsBodyNyamuk.affectedByGravity = false
        nyamuk.physicsBody = physicsBodyNyamuk
        
        self.addChild(nyamuk)
        nyamuk.run(completeAction)
        
        //if else
        if randomNyamuk() == "nyamuk-standart-1" {
            nyamuk.run(fly1, withKey: "terbang")
        }else if randomNyamuk() == "nyamuk-kilat-1"{
            nyamuk.run(fly2, withKey: "terbang")
        }else{
            nyamuk.run(fly3, withKey: "terbang")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if counter < 2{
            labelCounterNyamuk.text = "\(counter) Hit"
        }else{
            labelCounterNyamuk.text = "\(counter) Hits"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode{
            switch node {
            case exitNode:
                removeAllActions()
                if let scene = SKScene(fileNamed:"MainMenuScene"){
                    let fadeOut = SKTransition.fade(withDuration: 1)
                    scene.scaleMode = scaleMode
                    view?.presentScene(scene, transition: fadeOut)
                }
            default:
                let location = touch.location(in: self)
                tool.position.x = location.x
                tool.position.y = location.y
                print(tool.position)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tool.position = CGPoint(x: 414, y: 85)
    }
    
    func soundEffect(){
        let squashed = SKAudioNode(fileNamed: "squashed.mp3")
        squashed.autoplayLooped = false
        addChild(squashed)
        squashed.run(SKAction.play(), withKey: "squashed")
    }
    
    func setupFlyAction(){
        for i in 1...5{
            texture1.append(SKTexture(imageNamed: "nyamuk-standart-"+"\(i)"))
            fly1 = SKAction.repeatForever(SKAction.animate(with: texture1, timePerFrame: 0.05))
        }
        for i in 1...5{
            texture2.append(SKTexture(imageNamed: "nyamuk-kilat-"+"\(i)"))
            fly2 = SKAction.repeatForever(SKAction.animate(with: texture2, timePerFrame: 0.05))
        }
        for i in 1...5{
            texture3.append(SKTexture(imageNamed: "nyamuk-gemuk-"+"\(i)"))
            fly3 = SKAction.repeatForever(SKAction.animate(with: texture3, timePerFrame: 0.05))
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
            node!.physicsBody?.categoryBitMask = 0
            soundEffect()
            node!.run(SKAction.removeFromParent())
            self.removeAction(forKey: "squashed")
            
            counter+=1
            if counter % 5 == 0{
                self.run(respawn, withKey: "respawnNyamuk")
            }
            
        }
    }
}
