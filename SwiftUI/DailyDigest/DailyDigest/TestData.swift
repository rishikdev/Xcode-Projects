//
//  TestData.swift
//  DailyDigest
//
//  Created by Rishik Dev on 13/04/23.
//

import Foundation

struct TestData: Decodable {
    static var data = News(status: "ok", totalResults: 5, articles: [
        Article(source: Source(name: "Gizmodo.com"),
                author: "Kyle Barr",
                title: "Apple Might Be Ditching Touch-Based Buttons on iPhone 15",
                description: "Just what the hell is happening with the iPhone 15’s external buttons?",
                url: "https://gizmodo.com/apple-iphone-15-taptic-touch-buttons-kuo-leak-stocks-1850329674",
                urlToImage: "https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/b558aca2b1840775126207dd108844af.jpg",
                publishedAt: "2023-04-12T21:35:00Z",
                content: "Just what the hell is happening with the iPhone 15s external buttons? Despite numerous leaks and countless reports that premium iPhone 15s would ditch physical buttons and get new, trackpad-like touc… [+3383 chars]"),
        
        Article(source: Source(name: "Android Central"),
                author: "michael.hicks@futurenet.com (Michael L Hicks)",
                title: "Google One VPN vs. Apple iCloud Private Relay",
                description: "Apple and Google each have their own ways to keep your browsing private, but without some of the perks that many VPNs offer.",
                url: "https://www.androidcentral.com/apps-software/google-one-vpn-vs-apple-icloud-private-relay",
                urlToImage: "https://cdn.mos.cms.futurecdn.net/Lfmu83VeF7xuET9RXHy7hE-1200-80.jpg",
                publishedAt: "2023-04-12T15:15:56Z",
                content: "After a series of acquisitions and mergers, many of the best VPN services fall under the same few corporate umbrellas. It's not always clear who owns your information, and you'll have to pay a decent… [+8112 chars]"),
        
        Article(source: Source(id: "business-insider", name: "Business Insider"),
                author: "Jenny McGrat",
                title: "The best smart light bulbs in 2023",
                description: "We tested over 20 smart light bulbs to find the best LEDs that brighten a room via app or voice control, including white and color-changing options.",
                url: "https://www.businessinsider.com/guides/tech/best-smart-light-bulbs",
                urlToImage: "https://i.insider.com/6437200e5f081b0019c0ec25?width=1200&format=jpeg",
                publishedAt: "2023-04-12T21:42:41Z",
                content: "When you buy through our links, Insider may earn an affiliate commission. Learn more.Smart light bulbs are the easiest way to smarten up your home.Jenny McGrath/Insider\r\nSmart lights are easily the b… [+20418 chars]"),
        
        Article(source: Source(id: "vice-news", name: "Vice News"),
                author: "Magdalene Taylor, Duncan Cooper",
                title: "Why Is Everyone Talking About ‘Balancing Their Hormones?’",
                description: "Wake up. Look at the sun. Eat carrot salad. Fix your estrogen levels.",
                url: "https://www.vice.com/en/article/7kxvva/balancing-hormones-trend-experts-advice",
                urlToImage: "https://video-images.vice.com/articles/6436e56b62d7c00532572c99/lede/1681319294908-4112023hormonebalancingcvsite-lede-copy.jpeg?image-resize-opts=Y3JvcD0xeHc6MC45OTk5MDIxMTQzMzA0NjJ4aDtjZW50ZXIsY2VudGVyJnJlc2l6ZT0xMjAwOiomcmVzaXplPTEyMDA6Kg",
                publishedAt: "2023-04-12T18:38:27Z",
                content: "Wake up. Go outside and stare at the sun for 10 minutes. Go inside. Make breakfast consisting of at least 30 grams of protein. Do not drink coffee until at least half an hour after you’ve completed t… [+6904 chars]"),
        
        Article(source: Source(name: "MakeUseOf"),
                author: "Olasubomi Gbenjo",
                title: "9 Apple Mail Search Tips for Mac Users to Get the Desired Results",
                description: "Search for emails on your Mac quickly and efficiently with these valuable tips.",
                url: "https://www.makeuseof.com/search-tips-for-apple-mail-on-mac/",
                urlToImage: "https://static1.makeuseofimages.com/wordpress/wp-content/uploads/2023/04/image-of-a-macbook-on-a-white-table-with-fingers-on-the-keyboard.jpg",
                publishedAt: "2023-04-12T20:15:16Z",
                content: "Wading through tons of emails to find the one you're looking for can be a hassle. Even when searching for a specific email, you might still have to scroll through the search results until you find th… [+6973 chars]"),
    ])
}
