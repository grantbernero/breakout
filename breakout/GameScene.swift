//
//  GameScene.swift
//  breakout
//
//  Created by GBernero on 3/9/17.
//  Copyright © 2017 GBernero. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var ball: SKSpriteNode!
    
    var paddle: SKSpriteNode!
    
    var brick: SKSpriteNode!
    
    var brickHit = 0
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)//constraint around edge of the screen
        createBackground()
        makeBall()
        makePaddle()
        makeLoseZone()
        createBlocks()
        ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 3)) //puts ball in motion
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.name == "brick" || contact.bodyB.node?.name == "brick"
        {
            print("You win!")
            contact.bodyB.node?.removeFromParent()
            
        }
        else if contact.bodyA.node?.name == "lozeZone" || contact.bodyB.node?.name == "lozeZone"
        {
            print("You Lose!")
        }
    }
    
    func createBackground()
    {
        let stars = SKTexture(imageNamed: "stars")
        
        for i in 0...1
        {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height * CGFloat(i) - CGFloat(1 * i)))
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    
    func makeBall()
    {
        let ballDiameter = frame.width / 20
        ball = SKSpriteNode(color: UIColor.green, size: CGSize(width: ballDiameter, height: ballDiameter))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        addChild(ball)
    }
    
    func makePaddle()
    {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width / 4, height: frame.height / 25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    func makeBrick(xPoint: Int, yPoint: Int, brickWidth: Int, brickHeight: Int)
    {
        brick = SKSpriteNode(color: UIColor.red, size: CGSize(width: brickWidth, height: brickHeight))
        brick.position = CGPoint(x: xPoint, y: yPoint)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
    }
    
    func makeLoseZone()
    {
        let lozeZone = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: frame.width, height: 50))
        lozeZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        lozeZone.name = "lozeZone"
        lozeZone.physicsBody = SKPhysicsBody(rectangleOf: lozeZone.size)
        lozeZone.physicsBody?.isDynamic = false
        addChild(lozeZone)
    }
    
    func createBlocks()
    {
        var xPosition = Int(frame.midX - (frame.width / 2))
        var yPosition = 150
        
        let blockWidth = (Int)((frame.width - 60) / 6)
        let blockHeight = 20
        
        for rows in 1...3
        {
            for columns in 1...5
            {
                makeBrick(xPoint: xPosition, yPoint: yPosition, brickWidth: blockWidth, brickHeight: blockHeight)
                xPosition += (blockWidth + 30)
            }
            xPosition = Int(frame.midX - (frame.width / 2))
            yPosition += (blockHeight + 10)
            
        }
        
    }
    
   // func isGameWon() -> Bool
    //{
    // "if there are 0 blocks left, you win"
    //}
    //
   // func isGameLost() -> Bool
   // {
    // "if the ball is below the paddle, you lose"
   // }
}
