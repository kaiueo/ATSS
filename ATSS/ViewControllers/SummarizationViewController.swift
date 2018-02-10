//
//  SummarizationViewController.swift
//  ATSS
//
//  Created by 张克 on 10/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class SummarizationViewController: UIViewController {

    var summarizedArticle: SummarizedArticle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var summarizationStrings = ""
        for summarization in summarizedArticle.summary {
            summarizationStrings += summarization + "\n"
        }
        
        let font = UIFont(name: summarizationTextView.font!.fontName, size: CGFloat(16))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(12)
        
        let attributedString = NSMutableAttributedString(string: summarizationStrings)
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedStringKey.font, value: font!, range: NSRange(location: 0, length: attributedString.length))
        
        summarizationTextView.attributedText = attributedString

        // Do any additional setup after loading the view.
    }
    @IBAction func showOriginArticleButtonDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: StoryBoardConfigs.SummarizationToOriginArticleSegue, sender: summarizedArticle.article)
    }
    
    @IBOutlet weak var summarizationTextView: DesignableTextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == StoryBoardConfigs.SummarizationToOriginArticleSegue {
            let toView = segue.destination as! OriginArticleViewController
            toView.article = sender as! String
        }
    }
    

}

