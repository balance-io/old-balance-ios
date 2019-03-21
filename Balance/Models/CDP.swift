import Foundation

struct CDP: Codable {
    let id: Int?
    let ratio: Double?
    let pip: Double?
    let art: Double?
    let ink: Double?
    let liqPrice: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case ratio = "ratio"
        case pip = "pip"
        case art = "art"
        case ink = "ink"
        case liqPrice = "liq_price"
    }
}
