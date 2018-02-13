//
//  TextOrURLInputViewController.swift
//  ATSS
//
//  Created by 张克 on 09/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class TextOrURLInputViewController: UIViewController {

    
    var count: Int! {
        didSet{
            countLabel.text = String(count)
        }
    }
    
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
    @IBOutlet weak var countSlider: UISlider!
    @IBAction func closeButtonDidTouch(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func emptyButtonDidTouch(_ sender: UIBarButtonItem) {
        contentTextView.text = ""
    }
    
    @IBAction func summaryButtonDidTouch(_ sender: UIBarButtonItem) {
        view.showLoading()
        let articleOrUrl = ArticleOrURL()
        articleOrUrl.type = articleType
        articleOrUrl.count = count
        articleOrUrl.content = contentTextView.text
        ATSSNetworkHelper.getSummary(from: articleOrUrl) {
            (summarizedArticle, code) in
            self.view.hideLoading()
            if summarizedArticle != nil{
                let currentDate = Date()
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = " YYYY-MM-dd HH:mm:ss"
                let date = dateformatter.string(from: currentDate)
                let recentSummary = UserDefaults.standard.object(forKey: UserDefaultsStrings.RecentSummary)
                if var recent = recentSummary as? [[String: [String:[String]]]] {
                    if recent.count>=20 {
                        _ = recent.popLast()
                    }
                    recent.insert([date: [summarizedArticle!.article: summarizedArticle!.summary]], at: 0)
                    print(recent)
                    UserDefaults.standard.set(recent, forKey: UserDefaultsStrings.RecentSummary)
                }else {
                    var recent: [[String: [String:[String]]]] = []
                    recent.insert([date: [summarizedArticle!.article: summarizedArticle!.summary]], at: 0)
                    print(recent)
                    UserDefaults.standard.set(recent, forKey: UserDefaultsStrings.RecentSummary)
                }
                self.performSegue(withIdentifier: StoryBoardConfigs.TextOrURLInputToSummarizationSegue, sender: summarizedArticle)
            }
            else{
                if code == ResponseCode.NO_AMOUNT.rawValue {
                    self.messageLabel.text = "今日余量已用完，请上传"
                }else {
                    self.messageLabel.text = "失败，请检查网络"
                }
                self.messageView.animation = "slideDown"
                self.messageView.animate()
            }
            
        }
        
        
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func confirmButtonDidTouch(_ sender: Any) {
        messageView.animation = "fall"
        messageView.animate()
    }
    @IBOutlet weak var messageView: DesignableView!
    @IBOutlet weak var countLabel: UILabel!
    override func viewDidLoad() {

        super.viewDidLoad()
        count = Int(countSlider.value)
        contentTextView.delegate = self
        countSlider.addTarget(self, action: #selector(changed(slider:)), for: .valueChanged)
        
        

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var contentTextView: DesignableTextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func changed(slider: UISlider) {
         count = Int(countSlider.value)
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

extension TextOrURLInputViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let font = UIFont(name: textView.font!.fontName, size: CGFloat(16))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(12)
        
        let attributedString = NSMutableAttributedString(string: textView.text)
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedStringKey.font, value: font!, range: NSRange(location: 0, length: attributedString.length))
        
        textView.attributedText = attributedString
    }
}
