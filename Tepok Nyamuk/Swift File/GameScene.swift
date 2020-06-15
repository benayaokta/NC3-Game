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
    var fly: SKAction!
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
        respawn = SKAction.sequence([delay, generateMany])
        run(respawn, withKey: "respawnNyamuk")
    }
    
    func spawnNyamuk(){
        //buat sprite node isinya texture nyamuk
        nyamuk = SKSpriteNode(imageNamed: "nyamuk-gemuk-1")
        nyamuk.name = "nyamuk"
        nyamuk.size = CGSize(width: 165, height: 90)
        
        //atur posisi
        let randomXDistribution = GKRandomDistribution(lowestValue: 10, highestValue: 810)
        let xPosition = CGFloat(randomXDistribution.nextInt())
        
        let randomYDistribution = GKRandomDistribution(lowestValue: 550, highestValue: 1120)
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
        let physicsBodyNyamuk = SKPhysicsBody(circleOfRadius: 50)
        physicsBodyNyamuk.categoryBitMask = PhysicsCategory.nyamuk
        physicsBodyNyamuk.contactTestBitMask = PhysicsCategory.tool
        //buat dia terbang
        physicsBodyNyamuk.affectedByGravity = false
        nyamuk.physicsBody = physicsBodyNyamuk
        
        self.addChild(nyamuk)
        nyamuk.run(completeAction)
        nyamuk.run(fly, withKey: "terbang")
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
            case tool:
                zappedAction()
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
    
    func zappedAction(){
        let sound = SKAudioNode(fileNamed: "zapped.mp3")
        sound.autoplayLooped = false
        addChild(sound)
        sound.run(SKAction.play(), withKey: "zappedEffect")
    }
    
    func setupFlyAction(){
        var texture = [SKTexture]()
        for i in 1...5{
            texture.append(SKTexture(imageNamed: "nyamuk-gemuk-"+"\(i)"))
        }
        fly = SKAction.repeatForever(SKAction.animate(with: texture, timePerFrame: 0.05))
    }
    
    func soundEffect(){
        let sound = SKAudioNode(fileNamed: "electrocuted.mp3")
        sound.autoplayLooped = false
        addChild(sound)
        sound.run(SKAction.play(), withKey: "soundEffect")
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let bitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if bitMask == PhysicsCategory.nyamuk | PhysicsCategory.tool{
            counter += 1
            var node: SKNode? = nil
            if contact.bodyA.node?.name == "nyamuk" {
                node = contact.bodyA.node
            }else{
                node = contact.bodyB.node
            }
            node!.physicsBody?.categoryBitMask = 0
            soundEffect()
            node!.run(SKAction.removeFromParent())
            
            if counter % 5 == 0{
                //node nya masih nambah terus, ga berkurang
                self.run(respawn, withKey: "respawnNyamuk")
            }
            
        }
    }
}
