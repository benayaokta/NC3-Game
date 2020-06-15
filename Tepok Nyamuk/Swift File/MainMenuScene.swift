//
//  MainMenuScene.swift
//  Tepok Nyamuk
//
//  Created by Benaya Oktavianus on 12/06/20.
//  Copyright © 2020 -. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let bgMusic = SKAudioNode(fileNamed: "bgMusic.mp3")
        addChild(bgMusic)
        let volume = SKAction.changeVolume(by: 0.05, duration: 0)
        bgMusic.run(SKAction.group([volume,SKAction.play()]))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let startNode = childNode(withName: "startButton") as! SKSpriteNode
        if startNode.frame.contains(touch.location(in: self)){
            if let scene = SKScene(fileNamed: "GameScene"){
                let fadeOut = SKTransition.fade(withDuration: 2)
                scene.scaleMode = scaleMode
                view?.presentScene(scene, transition: fadeOut)
            }
        }
    }
}
