//
//  OriginArticleViewController.swift
//  ATSS
//
//  Created by 张克 on 10/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class OriginArticleViewController: UIViewController {
    
    var article: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont(name: originArticleTextView.font!.fontName, size: CGFloat(16))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(12)
        
        let attributedString = NSMutableAttributedString(string: article)
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedStringKey.font, value: font!, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor(hex:"EFEFF4"), range: NSRange(location: 0, length: attributedString.length))
        
        originArticleTextView.attributedText = attributedString

        // Do any additional setup after loading the view.
    }
    @IBAction func hideButtonDidTouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var originArticleTextView: DesignableTextView!
    
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

extension OriginArticleViewController: UITextViewDelegate {
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
