//
//  MainMenuScene.swift
//  Tepok Nyamuk
//
//  Created by Benaya Oktavianus on 12/06/20.
//  Copyright © 2020 -. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
//        let bgMusic = SKAudioNode(fileNamed: <#T##String#>)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let startNode = childNode(withName: "startButton") as! SKSpriteNode
        if startNode.frame.contains(touch.location(in: self)){
            if let scene = SKScene(fileNamed: "GameScene"){
                scene.scaleMode = scaleMode
                view?.presentScene(scene)
            }
        }
        
    }
}
