//
//  PostCell.swift
//  CombineMVVM
//
//  Created by Rishik Dev on 28/06/23.
//

import SwiftUI

struct PostCell: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(post.title)
                .fontWeight(.semibold)
            
            Text(post.body)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post: Post(userId: 1,
                            id: 1,
                            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                            body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"))
        .previewLayout(.sizeThatFits)
    }
}
