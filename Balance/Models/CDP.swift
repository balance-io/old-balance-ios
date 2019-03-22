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
    
    static func sortById(left: CDP, right: CDP) -> Bool {
        if let leftId = left.id, let rightId = right.id {
            return leftId < rightId
        }
        return false
    }
}
