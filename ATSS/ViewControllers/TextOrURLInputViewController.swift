//
//  TextOrURLInputViewController.swift
//  ATSS
//
//  Created by 张克 on 09/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class TextOrURLInputViewController: UIViewController {

    var articleType: ArticleType! {
        didSet {
            switch articleType! {
            case .Text:
                self.title = "文本"
            case .URL:
                self.title = "URL"
            }
        }
    }
    @IBAction func closeButtonDidTouch(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func emptyButtonDidTouch(_ sender: UIBarButtonItem) {
        contentTextView.text = ""
    }
    
    @IBAction func summaryButtonDidTouch(_ sender: UIBarButtonItem) {
        let articleOrUrl = ArticleOrURL()
        articleOrUrl.type = articleType
        articleOrUrl.count = 3
        articleOrUrl.content = contentTextView.text
        ATSSNetworkHelper.getSummary(from: articleOrUrl) {
            (summarizedArticle) in
            self.performSegue(withIdentifier: StoryBoardConfigs.TextOrURLInputToSummarizationSegue, sender: summarizedArticle)
        }
        
        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var contentTextView: DesignableTextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == StoryBoardConfigs.TextOrURLInputToSummarizationSegue {
            let toView = segue.destination as! SummarizationViewController
            toView.summarizedArticle = sender as! SummarizedArticle
        }
    }
    

}
