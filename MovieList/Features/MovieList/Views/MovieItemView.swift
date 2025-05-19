import SwiftUI

struct MovieItemView: View {
    let movie: MovieSummary
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: movie.poster ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
                    .opacity(0.3)
            }
            .frame(height: 200)
            
            Text(movie.title)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            if let year = movie.year {
                Text(year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
} 