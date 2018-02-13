//
//  SelfViewController.swift
//  ATSS
//
//  Created by 张克 on 12/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class SelfViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()

        // Do any additional setup after loading the view.
    }
    
    func loadUser(){
        ATSSNetworkHelper.getUser {
            (user) in
            if user != nil {
                self.usernamaLabel.text = user?.username
                self.createLabel.text = user?.created_at
                self.usageLabel.text = self.getRemain(use: user!.use, uploads: user!.uploads)
                self.biographyLabel.text = user?.biography
                let avatar = user?.avatar
                ATSSNetworkHelper.getImage(from: avatar!) {
                    (image) in
                    self.avatarImageView.image = image
                }
            }
        }
        
    }
    
    func getRemain(use: Int, uploads: Int) -> String{
        let amount = uploads / 10 + 10
        return "  用量：\(use)/\(amount)"
        
    }
    
    @IBAction func logoutButtonDidTouch(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsStrings.UserInfoString)
        UserDefaults.standard.removeObject(forKey: UserDefaultsStrings.RecentSummary)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func freshButtonDidTouch(_ sender: Any) {
        loadUser()
    }
    @IBOutlet weak var biographyLabel: DesignableTextView!
    @IBOutlet weak var usageLabel: DesignableLabel!
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var usernamaLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
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
