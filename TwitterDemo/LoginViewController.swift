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

    @IBAction func loginDidClicked(_ sender: UIButton) {
        
        let callbackURL = URL(string: "linh://")
        
        TweeterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: callbackURL, scope: nil, success: { (response: BDBOAuth1Credential?) in
            if let response = response{
                print("request token: \(response.token)")
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)                
            }
        }, failure: { (error: Error?) in
            print(error?.localizedDescription ?? "")
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
