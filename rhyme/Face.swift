//
//  ViewController.swift
//  rhyme
//
//  Created by Arjun Iyer on 11/15/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import UIKit


protocol FaceDelegate {
    
    func handlePressBegan()
    
    func handlePressEnded()
    
    func handleTap()
    
}

class Face: UIViewController {
    
    var delegate : FaceDelegate?
    var tap : UITapGestureRecognizer!
    var press : UILongPressGestureRecognizer!
    
    static let faceDidAppearNotification = Notification.Name(rawValue: "FaceDidAppearNotification")
    @IBOutlet weak var stateLabel: UILabel!
    
    func enableGestures(){
        enableTap()
        enablePress()
    }
    
    func disableGestures(){
        disableTap()
        disablePress()
    }
    
    func enableTap(){
        tap.isEnabled = true
    }
    
    func disableTap(){
        tap.isEnabled = false
    }
    
    func enablePress(){
        press.isEnabled = true
    }
    
    func disablePress(){
        press.isEnabled = false
    }
    @objc func handleTap(_ gestureRecognizer:UITapGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleTap()
            break
        default:
            break
        }
    }
    
    @objc func handlePress(_ gestureRecognizer:UILongPressGestureRecognizer){
        switch gestureRecognizer.state {
        case .began:
            delegate?.handlePressBegan()
            break
        case .ended,.cancelled:
            delegate?.handlePressEnded()
            break
        default:
            break
        }
    }
    
    @objc func dispatchDotState(_ string:String){
        
        DispatchQueue.main.async {
            
            self.stateLabel.text = string
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(Notification(name: Face.faceDidAppearNotification,object:self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(_:)))
        press.minimumPressDuration = 0.2
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(press)
    }


}

