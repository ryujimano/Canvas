//
//  ViewController.swift
//  Canvas
//
//  Created by Ryuji Mano on 3/23/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var downArrow: UIImageView!
    var trayOriginalCenter: CGPoint!
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffset = 180
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: translation.y + trayOriginalCenter.y)
        }
        else if sender.state == .ended {
            var velocity = sender.velocity(in: view)
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayDown
                    self.downArrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                }, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayUp
                    self.downArrow.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                }, completion: nil)
            }
        }
    }
    
    @IBAction func createdFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            var faceView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: faceView.image)
            view.addSubview(newlyCreatedFace)
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.isUserInteractionEnabled = true
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
            self.newlyCreatedFace.center = faceView.center
            self.newlyCreatedFace.center.y += self.trayView.frame.origin.y
            self.newlyCreatedFaceOriginalCenter = self.newlyCreatedFace.center
            UIView.animate(withDuration: 0.1, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        }
        else if sender.state == .changed {
            self.newlyCreatedFace.center = CGPoint(x: self.newlyCreatedFaceOriginalCenter.x + translation.x, y: self.newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            if newlyCreatedFace.center.y > trayView.frame.origin.y {
                UIView.animate(withDuration: 0.3, animations: {
                    self.newlyCreatedFace.removeFromSuperview()
                    return
                })
            }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: 0.7, y: 0.7)
            }, completion: nil)
        }
    }
    
    func didPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            UIView.animate(withDuration: 0.1, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        }
        else if sender.state == .changed {
             newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            if newlyCreatedFace.center.y > trayView.frame.origin.y {
                UIView.animate(withDuration: 0.3, animations: {
                    self.newlyCreatedFace.removeFromSuperview()
                    return
                })
            }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: 0.7, y: 0.7)
            }, completion: nil)
        }
    }

    func didPinch(_ sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        if sender.state == .changed {
            newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: scale, y: scale)
            sender.scale = 1
        }
    }
    
    func didRotate(_ sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        if sender.state == .changed {
            newlyCreatedFace.transform = newlyCreatedFace.transform.rotated(by: rotation)
            sender.rotation = 0
        }
    }
    
    func didTap(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
}

