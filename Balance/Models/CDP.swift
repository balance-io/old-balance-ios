import Foundation

// API Reference

//guard let url = URL(string: "https://mkr.tools/api/v1/cdp/14165") else {return}// a CDP

//[["block": 7154155,
//    "tab": 42249.60231457469,
//    "time": 2019-01-31T14:34:47.000Z, TODO
//    "id": 14165,
//    "ratio": 281.664015430498,
//    "lad": 0x507c0d38456a75b56d938228f0eb8Df00E2A2f15,
//    "art": 15000,
//    "deleted": 0, TODO
//    "arg": <null>, TODO
//    "pip": 145.635,
//    "ink": 278.7336414172244,
//    "pep": 645.17,
//    "timestamp": 1548945287000, TODO
//    "ire": 14825.62108276614,
//    "per": 1.040800462956618,
//    "act": give,
//    "liq_price": 77.55783061819776]]


struct CDP: Codable {
    let id: Int?
    let ratio: Double?
    let lad: String?
    let art: Double?
    let pip: Double?
    let ink: Double?
    let pep: Double?
    let ire: Double?
    let per: String?
    let act: String?
    let liqPrice: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case ratio = "ratio"
        case lad = "lad"
        case art = "art"
        case pip = "pip"
        case ink = "ink"
        case pep = "pep"
        case ire = "ire"
        case per = "per"
        case act = "act"
        case liqPrice = "liq_price"
    }
    
    static func sortById(left: CDP, right: CDP) -> Bool {
        if let leftId = left.id, let rightId = right.id {
            return leftId < rightId
        }
        return false
    }
}

// Contract Reference

//https://github.com/bokkypoobah/MakerDAOSaiContractAudit/blob/master/audit/checkComponents/saiTub.sol#L634

// contract SaiTub is DSThing, SaiTubEvents {
//     DSToken  public  sai;  // Stablecoin
//     DSToken  public  sin;  // Debt (negative sai)

//     DSToken  public  skr;  // Abstracted collateral
//     ERC20    public  gem;  // Underlying collateral

//     DSToken  public  gov;  // Governance token

//     SaiVox   public  vox;  // Target price feed
//     DSValue  public  pip;  // Reference price feed
//     DSValue  public  pep;  // Governance price feed

//     address  public  tap;  // Liquidator
//     address  public  pit;  // Governance Vault

//     uint256  public  axe;  // Liquidation penalty
//     uint256  public  cap;  // Debt ceiling
//     uint256  public  mat;  // Liquidation ratio
//     uint256  public  tax;  // Stability fee
//     uint256  public  fee;  // Governance fee
//     uint256  public  gap;  // Join-Exit Spread

//     bool     public  off;  // Cage flag
//     bool     public  out;  // Post cage exit

//     uint256  public  fit;  // REF per SKR (just before settlement)

//     uint256  public  rho;  // Time of last drip
//     uint256         _chi;  // Accumulated Tax Rates
//     uint256         _rhi;  // Accumulated Tax + Fee Rates
//     uint256  public  rum;  // Total normalised debt

//     uint256                   public  cupi;
//     mapping (bytes32 => Cup)  public  cups;

//     struct Cup {
//         address  lad;      // CDP owner
//         uint256  ink;      // Locked collateral (in SKR)
//         uint256  art;      // Outstanding normalised debt (tax only)
//         uint256  ire;      // Outstanding normalised debt
//     }
