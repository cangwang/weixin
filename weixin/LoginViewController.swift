//
//  LoginViewController.swift
//  weixin
//
//  Created by air on 15/4/18.
//  Copyright (c) 2015年 air. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userTF: UITextField!
    
    @IBOutlet weak var pwdTF: UITextField!
    
    @IBOutlet weak var serverTF: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var autologininSwitch: UISwitch!

    //登录标示
    var requireLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as! UIBarButtonItem == self.doneButton {
            NSUserDefaults.standardUserDefaults().setObject(userTF.text, forKey: "weixinID")
            NSUserDefaults.standardUserDefaults().setObject(pwdTF.text, forKey: "weixinPwd")
            NSUserDefaults.standardUserDefaults().setObject(serverTF.text, forKey: "wxserver")
            
            NSUserDefaults.standardUserDefaults().setBool(self.autologininSwitch.on, forKey: "wxautologin")
            
            
            //同步用户配置
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //可以登录
            requireLogin = true
        }
    }
    

}
