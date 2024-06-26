//
//  File.swift
//  
//
//  Created by amine on 07/04/2024.
//

import Foundation
import Plot
import Publish

typealias ThemeWebsite = Markpages

extension Theme where Site == ThemeWebsite {
    /// The default "Foundation" theme that Publish ships with, a very
    /// basic theme mostly implemented for demonstration purposes.
    static var basic: Self {
        Theme(
            htmlFactory: BasicHTMLFactory(),
            resourcePaths: ["/Resources/BasicTheme/styles.css"]
        )
    }
}

private struct BasicHTMLFactory: HTMLFactory {
    
    func makeIndexHTML(
        for index: Index,
        context: PublishingContext<ThemeWebsite>
    ) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: Markpages.SectionID.home)
                Wrapper(index.body)
                SiteFooter()
            }
        )
    }

    func makeSectionHTML(
        for section: Section<ThemeWebsite>,
        context: PublishingContext<ThemeWebsite>
    ) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: section.id)
                Wrapper {
                    Wrapper(section.body)
                    ItemList(items: section.items, site: context.site)
                }
                SiteFooter()
            }
        )
    }

    func makeItemHTML(
        for item: Item<ThemeWebsite>,
        context: PublishingContext<ThemeWebsite>
    ) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .components {
                    SiteHeader(context: context, selectedSelectionID: item.sectionID)
                    Wrapper {
                        Article {
                            Div(item.content.body).class("content")
                            Span("Tagged with: ")
                            ItemTagList(item: item, site: context.site)
                        }
                    }
                    SiteFooter()
                }
            )
        )
    }

    func makePageHTML(
        for page: Page,
        context: PublishingContext<ThemeWebsite>
    ) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper(page.body)
                SiteFooter()
            }
        )
    }

    func makeTagListHTML(
        for page: TagListPage,
        context: PublishingContext<ThemeWebsite>
    ) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    H1("Browse all tags")
                    List(page.tags.sorted()) { tag in
                        ListItem {
                            Link(tag.string,
                                 url: context.site.path(for: tag).absoluteString
                            )
                        }
                        .class("tag")
                    }
                    .class("all-tags")
                }
                SiteFooter()
            }
        )
    }

    func makeTagDetailsHTML(
        for page: TagDetailsPage,
        context: PublishingContext<ThemeWebsite>
    ) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    H1 {
                        Text("Tagged with ")
                        Span(page.tag.string).class("tag")
                    }

                    Link("Browse all tags",
                        url: context.site.tagListPath.absoluteString
                    )
                    .class("browse-all")

                    ItemList(
                        items: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        site: context.site
                    )
                }
                SiteFooter()
            }
        )
    }
}

private struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}

private struct SiteHeader<Site: Website>: Component {
    var context: PublishingContext<Site>
    var selectedSelectionID: Site.SectionID?
    var contactEmail: String = Constants.contactEmail

    var body: Component {
        Header {
            Wrapper {
                Link(context.site.name, url: "/")
                    .class("site-name")

                if Site.SectionID.allCases.count > 1 {
                    navigation
                }
            }
        }
    }

    private var navigation: Component {
        Navigation {
            List(Site.SectionID.allCases) { sectionID in
                if sectionID.rawValue == Markpages.SectionID.home.rawValue {
                  return Link("Home", url: "/")
                        .class(sectionID.rawValue.lowercased() == selectedSelectionID?.rawValue.lowercased() ? "selected" : "")
                } else if sectionID.rawValue == Markpages.SectionID.contact.rawValue {
                    return Email(title: "Contact", email: contactEmail)
                } else {
                    let section = context.sections[sectionID]
                    
                    return Link(section.title,
                                url: section.path.absoluteString
                    )
                    .class(sectionID == selectedSelectionID ? "selected" : "")
                }
            }
        }
    }
}

private struct Email: Component {
    var title: String
    var email: String
    
    var body: Component {
        Link(title, url: URL(string: "mailto:\(email)")!)
    }
}

private struct ItemList<Site: Website>: Component {
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        List(items) { item in
            Article {
                H1(Link(item.title, url: item.path.absoluteString))
                ItemTagList(item: item, site: site)
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }
}

private struct ItemTagList<Site: Website>: Component {
    var item: Item<Site>
    var site: Site

    var body: Component {
        List(item.tags) { tag in
            Link(tag.string, url: site.path(for: tag).absoluteString)
        }
        .class("tag-list")
    }
}

private struct SiteFooter: Component {
    var body: Component {
        Footer {
            Paragraph {
                Text("Copyright © 2024 Markpages. All rights reserved.")
            }
        }
    }
}
