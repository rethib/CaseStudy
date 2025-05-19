import SwiftUI

struct MovieGridCell: View {
    let movie: MovieSummary
    let onFavoriteToggle: () -> Void
    
    // Define fixed cell size
    static let cellWidth: CGFloat = 170
    static let cellHeight: CGFloat = 320
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                // Poster Image
                AsyncImage(url: URL(string: movie.poster ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay {
                            Image(systemName: "film")
                                .foregroundColor(.gray)
                        }
                }
                .frame(width: Self.cellWidth, height: Self.cellWidth * 3 / 2)
                
                // Favorite Button
                Button(action: onFavoriteToggle) {
                    Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(movie.isFavorite ? .red : .white)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                if let year = movie.year {
                    Text(year)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: Self.cellWidth, alignment: .leading)
        }
        .frame(width: Self.cellWidth, height: Self.cellHeight)
    }
} 