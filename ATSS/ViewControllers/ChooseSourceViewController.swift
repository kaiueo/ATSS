//
//  ChooseSourceViewController.swift
//  ATSS
//
//  Created by 张克 on 09/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class ChooseSourceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var sourceChooseView: DesignableView!
    @IBOutlet weak var promptLabel: DesignableLabel!
    @IBAction func chooseSourceButtonDidTouch(_ sender: UIButton) {
        sourceChooseView.animation = "fall"
        promptLabel.animation = "fall"
        sourceChooseView.animate()
        promptLabel.animate()
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func urlButtonDidTouch(_ sender: DesignableButton) {
        self.performSegue(withIdentifier: StoryBoardConfigs.ChooseSourceToTextOrURLInputSegue, sender: ArticleType.URL)
        
    }
    
    @IBAction func textButtonDidTouch(_ sender: DesignableButton) {
        self.performSegue(withIdentifier: StoryBoardConfigs.ChooseSourceToTextOrURLInputSegue, sender: ArticleType.Text)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == StoryBoardConfigs.ChooseSourceToTextOrURLInputSegue {
            let nvc = segue.destination as! UINavigationController
            let toView = nvc.topViewController as! TextOrURLInputViewController
            toView.articleType = sender as! ArticleType
            
        }
    }
    

}
