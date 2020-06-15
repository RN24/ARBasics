//
//  ViewController.swift
//  ARTKit
//
//  Created by 西岡亮太 on 2020/06/12.
//  Copyright © 2020 西岡亮太. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
       
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        return configuration
        }()
        


        

        // Run the view's session
         sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        let ship = SCNScene(named: "art.scnassets/ship.scn")!
//        let shipNode = ship.rootNode.childNodes.first!
//        shipNode.scale = SCNVector3(0.1, 0.1, 0.1)
//
//        //スクリーン座標系
//        guard let location = touches.first?.location(in: sceneView) else{
//            return
//        }
//        let pos: SCNVector3 = SCNVector3(location.x, location.y, 0.996)
//
//        //ワールド座標系に変換
//        let finalPosition = sceneView.unprojectPoint(pos)
//        shipNode.position = finalPosition
//
//
//        sceneView.scene.rootNode.addChildNode(shipNode)
//    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let ship = SCNScene(named: "art.scnassets/ship.scn")!
        let shipNode = ship.rootNode.childNodes.first!
        shipNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
        //カメラ座標系で30センチ前
        let infrontCamera = SCNVector3Make(0, 0, -0.3)
        guard let cameraNode = sceneView.pointOfView else {
            return
        }
        
        //ワールド座標系に変換
        
        let pointInWorld = cameraNode.convertPosition(infrontCamera, to: nil)
        
        //スクリーン座標系へ変換
        var screenPositon = sceneView.projectPoint(pointInWorld)
        
        //スクリーン座標系
          guard let location = touches.first?.location(in: sceneView) else{
              return
          }
        screenPositon.x = Float(location.x)
        screenPositon.y = Float(location.y)
        
        //ワールド座標系
        let finalPosition = sceneView.unprojectPoint(screenPositon)
       
        shipNode.eulerAngles = cameraNode.eulerAngles
      
        shipNode.position = finalPosition
        sceneView.scene.rootNode.addChildNode(shipNode)
    }


    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        print("anchor added")
        
        if anchor is ARPlaneAnchor{
            print("this is ARPlaneAnchor.")
        }
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
