//
//  UploadSummaryViewController.swift
//  ATSS
//
//  Created by 张克 on 10/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class UploadSummaryViewController: UIViewController {
    
    var unsummarizedArticle: UnsummarizedArticle?
    var responseCode: ResponseCode?

    @IBOutlet weak var messageLabel: UILabel!
    @IBAction func confirmButtonDidTouch(_ sender: Any) {
        if responseCode != nil{
            switch responseCode! {
            case .SUCCESS:
                messageView.animation = "fall"
                messageView.animate()
                unsummarizedArticle = nil
                summaryTextView.text = ""
                view.showLoading()
                getNewArticle()
            default:
                messageView.animation = "fall"
                messageView.animate()
            }
        }
    }
    @IBOutlet weak var messageView: DesignableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryTextView.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var summaryTextView: DesignableTextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emptyButtonDidTouch(_ sender: Any) {
        summaryTextView.text = ""
        
    }
    
    @IBAction func refreshButtonDidTouch(_ sender: Any) {
        view.showLoading()
        getNewArticle()
        
    }
    
    @IBAction func showOriginButtonDidTouch(_ sender: Any) {
        if unsummarizedArticle != nil {
            self.performSegue(withIdentifier: StoryBoardConfigs.UploadSummaryToOriginArticleSegue, sender: unsummarizedArticle)
        }else {
            messageLabel.text = "请先获取待摘要文章"
            responseCode = ResponseCode.UNKNOEN_ERROR
            messageView.animation = "slideDown"
            messageView.animate()
        }
    }
    
    @IBAction func uploadButtonDidTouch(_ sender: Any) {

        if unsummarizedArticle != nil{
            view.showLoading()
            let summarization = summaryTextView.text
            let summarizationForUpload = SummarizationForUpload()
            summarizationForUpload.id = unsummarizedArticle?.id
            summarizationForUpload.summarization = summarization
            summarizationForUpload.text = unsummarizedArticle?.text
            ATSSNetworkHelper.upload(summarization: summarizationForUpload){
                (responseCode) in
                self.view.hideLoading()
                self.responseCode = responseCode
                switch responseCode {
                case .SUCCESS:
                    self.messageLabel.text = "上传成功"
                default:
                    self.messageLabel.text = "上传失败，请稍后再试"
                }
                self.messageView.animation = "slideDown"
                self.messageView.animate()
            }
        }else {
            messageLabel.text = "请先获取待摘要文章"
            responseCode = ResponseCode.UNKNOEN_ERROR
            messageView.animation = "slideDown"
            messageView.animate()
        }
        
        
    }
    
    func getNewArticle() {
        ATSSNetworkHelper.getUnsummarizedArticle {
            (unsummarizedArticle) in
            self.view.hideLoading()
            self.unsummarizedArticle = unsummarizedArticle
            if unsummarizedArticle != nil {
                self.performSegue(withIdentifier: StoryBoardConfigs.UploadSummaryToOriginArticleSegue, sender: unsummarizedArticle)
            }else{
                self.messageLabel.text = "暂无文章，请稍后再试"
                self.responseCode = ResponseCode.NO_ARTICLE
                self.messageView.animation = "slideDown"
                self.messageView.animate()
            }
            
            
            
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == StoryBoardConfigs.UploadSummaryToOriginArticleSegue {
            let toView = segue.destination as! OriginArticleViewController
            let unsummarizedArticle = sender as! UnsummarizedArticle
            toView.article = unsummarizedArticle.text
        }
        
        
    }
    

}

extension UploadSummaryViewController: UITextViewDelegate {
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
