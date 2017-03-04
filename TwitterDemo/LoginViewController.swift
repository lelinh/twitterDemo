//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/2/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!

    @IBAction func loginDidClicked(_ sender: UIButton) {
        
        let client = TweeterClient.sharedInstance
        
        client.login(success: { () -> () in
            print("login successfully!!")
            self.performSegue(withIdentifier: "timelineSegue", sender: nil)
        }){(error: NSError) -> () in
            print(error)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension LoginViewController{
    func configView() {
        loginButton.layer.cornerRadius = 7 //set corner for image here
        loginButton.clipsToBounds = true
    }
}
