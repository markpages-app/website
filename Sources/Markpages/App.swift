//
//  File.swift
//  
//
//  Created by amine on 07/04/2024.
//

import Foundation
import Publish
import Plot
import SplashPublishPlugin

public struct App {
    /// Create the application
    public init() {}

    public func run() throws {
        // This will generate your website using the built-in Foundation theme:
        try Markpages()
            .publish(
                using: [
                    .copyResources(),
                    .installPlugin(.splash(withClassPrefix: "")),
                    .installPlugin(.ensureAllItemsAreTagged),
                    .addMarkdownFiles(),
                    .generateHTML(withTheme: .basic),
                    //.createCNAME(website: Constants.website),
                    .generateSiteMap()
                ]
            )
    }
}
