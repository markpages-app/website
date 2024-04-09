import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct Markpages: Publish.Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case home
        case about
        case terms
        case privacy
        case contact
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: Constants.websiteUrl)!
    var name = Constants.appName
    var description = "A description of \(Constants.appName)"
    var language: Language { .english }
    var imagePath: Path? { nil }
}
