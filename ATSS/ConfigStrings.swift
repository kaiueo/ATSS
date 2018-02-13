//
//  ConfigStrings.swift
//  ATSS
//
//  Created by 张克 on 08/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import Foundation

struct StoryBoardConfigs {
    static let SummaryHistoryTableViewCellIdentifier = "SummaryHistoryTableViewCell"
    static let ChooseSourceToTextOrURLInputSegue = "ChooseSourceToTextOrURLInput"
    static let TextOrURLInputToSummarizationSegue = "TextOrURLInputToSummarization"
    static let SummarizationToOriginArticleSegue = "SummarizationToOriginArticle"
    static let UploadSummaryToOriginArticleSegue = "UploadSummaryToOriginArticle"
    static let LoginToHomeSegue = "LoginToHome"
    static let HistoryToSummarySegue = "HistoryToSummary"
}

struct UserDefaultsStrings {
    static let UserInfoString = "user-info"
    static let RecentSummary = "recent-summary"
}
