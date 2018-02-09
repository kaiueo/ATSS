//
//  LoginViewController.swift
//  ATSS
//
//  Created by 张克 on 09/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func loginButtonDidTouch(_ sender: DesignableButton) {
        ATSSNetworkHelper.uploadSummary(id: "NDM=\n", text: "IT之家 2月9日消息 今天 微软官方宣布了Build开发者大会 ，表示将于5月7日至9日在西雅图举办，目前官网已经接受开发者的注册。不过对于部分开发者尤其是多平台的开发者来说似乎有个不好的消息，那就是今年的微软Build大会确定将和谷歌I/O大会撞车。\n\nGoogleI/O大会的举办时间为5月8日至10日，地点位于加利福尼亚的山景城，很显然开发者不能同时参加两个科技巨头的盛会，于是参加微软Build 2018大会还是谷歌I/O大会成为了开发者一个艰难的选择。同一时间段两大科技公司的展会撞车也算是比较罕见的情况。\n\n当然无论微软Build 2018大会是否和谷歌I/O大会撞车， IT之家 还是会及时地播报这两场大会的最新消息以及相关的资讯。如果你是开发者的话，你会参加哪一场的发布会呢？\n\n开发者抓狂：微软Build开发者大会与谷歌I/O大会撞车\n\n", summarization: "i am hhhhh") {
            (json) in
            print(json)
        }
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
