//
//  Job.swift
//  DesignPatterns
//
//  Created by david martinez on 2/22/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

typealias Jobs = [Job]

struct Job: Decodable {
    let title: String
    let companyUrlString: String?
    let companyLogo: String?
    let companyName: String?
    let type: String?
    let description: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case type
        case description
        case location
        case companyUrlString = "company_url"
        case companyLogo = "company_logo"
        case companyName = "company"
    }
    
    var companyUrl: URL? {
        guard let companyUrlString = companyUrlString else { return nil }
        return URL(string: companyUrlString)
    }

    var imageUrl: URL? {
        guard let companyLogo = companyLogo else { return nil }
        return URL(string: companyLogo)
    }
    
    var attributedDescriptionText: NSAttributedString? {
        guard let htmlData = description?.data(using: String.Encoding.unicode) else {
            return nil
        }
        do {
            let attributedText = try NSAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedText
        } catch {
            print("Error \(error.localizedDescription) ")
            return nil
        }
    }
}
