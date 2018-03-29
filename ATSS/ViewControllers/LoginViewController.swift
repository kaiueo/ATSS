//
//  LoginViewController.swift
//  ATSS
//
//  Created by 张克 on 09/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginView: DesignableView!
    @IBOutlet weak var promptLabel: DesignableLabel!
    @IBOutlet weak var passwordLabel: DesignableTextField!
    @IBOutlet weak var usernameLabel: DesignableTextField!
    @IBAction func loginButtonDidTouch(_ sender: DesignableButton) {
        let username = usernameLabel.text!
        let password = passwordLabel.text!
        if username=="" || password=="" {
            self.errorHandle(errorMessage: "请输入用户名或密码")
            
        }else {
            promptLabel.isHidden = true
            ATSSNetworkHelper.getToken(username: username, password: password) {
                (username, password, code) in
                if code == nil {
                    self.errorHandle(errorMessage: "请检查网络连接")
                    
                }else if code==200 {
                    let userInfo: [String: Any] = ["username": username,
                                                   "password": password]
                    UserDefaults.standard.set(userInfo, forKey: UserDefaultsStrings.UserInfoString)
                    ATSSNetworkHelper.username = username
                    ATSSNetworkHelper.password = password
                    self.usernameLabel.text = ""
                    self.passwordLabel.text = ""
                    self.performSegue(withIdentifier: StoryBoardConfigs.LoginToHomeSegue, sender: nil)
                    
                }else {
                    self.errorHandle(errorMessage: "用户名或密码错误")
                    
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userInfo = UserDefaults.standard.object(forKey: UserDefaultsStrings.UserInfoString)
        if userInfo != nil {
            let user = userInfo as! [String: Any]
            ATSSNetworkHelper.username = user["username"] as! String
            ATSSNetworkHelper.password = user["password"] as! String
            self.performSegue(withIdentifier: StoryBoardConfigs.LoginToHomeSegue, sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorHandle(errorMessage: String){
        promptLabel.text = errorMessage
        promptLabel.isHidden = false
        loginView.animation = "shake"
        loginView.animate()
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
