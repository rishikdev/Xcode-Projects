//
//  FeedParser.swift
//  RSS
//
//  Created by Rishik Dev on 10/01/2025.
//

import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    private override init() {}
    static let shared = FeedParser()
    
    private var rssItems: [FeedItemModel] = []
    private var parseSuccessful: Bool = false
    private var currentElement: String = ""
    private var hasItems: Bool = false
    var currentOutlet: OutletModel = OutletModel(id: UUID())
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var currentLink: String = ""
    
    func parseFeed(from data: Data, for outlet: OutletModel) throws -> [FeedItemModel] {
        self.rssItems.removeAll()
        self.currentOutlet = outlet
        self.hasItems = false
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        if (hasItems && self.rssItems.isEmpty) {
            throw RSSError.parsingFailed
        }
        
        if (self.parseSuccessful) {
            return self.rssItems
        }
        
        throw RSSError.parsingFailed
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentElement = elementName
        
        if (currentElement == "item") {
            self.currentTitle = ""
            self.currentDescription = ""
            self.currentPubDate = ""
            self.currentLink = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch self.currentElement {
        case "title":
            self.currentTitle = self.currentTitle + string.decodeHTMLEntities().removingHTML()
            self.hasItems = true
        case "description":
            self.currentDescription = self.currentDescription + string.decodeHTMLEntities().removingHTML()
            self.hasItems = true
        case "pubDate":
            self.currentPubDate = self.currentPubDate + string
            self.hasItems = true
        case "link":
            self.currentLink = self.currentLink + string
            self.hasItems = true
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            self.rssItems.append(FeedItemModel(title: self.currentTitle,
                                               description: self.currentDescription,
                                               pubDate: self.currentPubDate,
                                               link: self.currentLink,
                                               outlet: self.currentOutlet))
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.parseSuccessful = true
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: any Error) {
        self.parseSuccessful = false
        print("Error parsing XML: \(parseError)")
    }
}
