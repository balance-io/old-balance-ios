import UIKit

//var str = "Hello, playground"
//
//var num = 12
//
//var numExplicit:NSInteger = 12
//
//var liq = 94
//
//var warning = "If the price of Ether drops to \(String(liq)) then the CDP will be liquidated and you will lose 13% of your collateral."
//
//
//var CDPs = [String]()
//
//CDPs.append(str)
//CDPs.append(warning)
//
//print(CDPs)
//
//for cdp in CDPs {
//    if cdp.first == "I" {
//
//    }
//}

let ethplorerJSON = "{\"address\":\"0x1db7332d24ebbdc5f49c34aa6830cb7f46a3647c\",\"ETH\":{\"balance\":0.1171826581562},\"countTxs\":170,\"tokens\":[{\"tokenInfo\":{\"address\":\"0xe41d2489571d322189246dafa5ebde1f4699f498\",\"name\":\"0x Protocol Token\",\"decimals\":\"18\",\"symbol\":\"ZRX\",\"totalSupply\":\"1000000000000000000000000000\",\"owner\":\"\",\"lastUpdated\":1552413595,\"issuancesCount\":0,\"holdersCount\":82333,\"ethTransfersCount\":33,\"price\":{\"rate\":0.270265077495,\"diff\":4.48,\"diff7d\":13.55,\"ts\":1552413785,\"marketCapUsd\":157887842.41261,\"availableSupply\":584196241.24589,\"volume24h\":17368084.757295,\"diff30d\":8.9348145943941,\"currency\":\"USD\"}},\"balance\":2.3586977692212e+21,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xc06c1d8dba472e5f9b1e45cbd3dadc1d79874d4c\",\"name\":\"PROVER.IO additional 5% discount\",\"decimals\":\"18\",\"symbol\":\"BONUS\",\"totalSupply\":\"10000000000000000000000000\",\"owner\":\"0x915c517cb57fab7c532262cb9f109c875bed7d18\",\"lastUpdated\":1549540450,\"issuancesCount\":0,\"holdersCount\":13480,\"price\":false},\"balance\":5.0e+18,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xcd3673af09e76c74d889aabab68ca0645566a3a1\",\"name\":\"Unicorn Candy Coin\",\"decimals\":\"18\",\"symbol\":\"Candy\",\"totalSupply\":\"12000000000000000000000000\",\"owner\":\"0x9740cd40296744a0ae2afd115933a791da4c2ad8\",\"lastUpdated\":1552263984,\"issuancesCount\":0,\"holdersCount\":19101,\"ethTransfersCount\":0,\"price\":false},\"balance\":2.5e+19,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x960b236a07cf122663c4303350609a66a7b288c0\",\"name\":\"Aragon Network Token\",\"decimals\":\"18\",\"symbol\":\"ANT\",\"totalSupply\":\"39609523809523809540000000\",\"owner\":\"\",\"lastUpdated\":1552413594,\"issuancesCount\":0,\"holdersCount\":20523,\"ethTransfersCount\":1952,\"price\":{\"rate\":0.439210873906,\"diff\":3.13,\"diff7d\":6.69,\"ts\":1552413783,\"marketCapUsd\":13049202.938755,\"availableSupply\":29710564.36446,\"volume24h\":11897.112750855,\"diff30d\":21.70651017649,\"currency\":\"USD\"}},\"balance\":2.81582250628e+21,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xa74476443119a942de498590fe1f2454d7d4ac0d\",\"name\":\"Golem Network Token\",\"decimals\":\"18\",\"symbol\":\"GNT\",\"totalSupply\":\"1000000000000000000000000000\",\"owner\":\"\",\"lastUpdated\":1552413595,\"issuancesCount\":0,\"holdersCount\":100975,\"ethTransfersCount\":620,\"price\":{\"rate\":0.0771196503984,\"diff\":8.84,\"diff7d\":17.9,\"ts\":1552413783,\"marketCapUsd\":74314191.756207,\"availableSupply\":963622000,\"volume24h\":11932028.827199,\"diff30d\":29.389500773759,\"currency\":\"USD\"}},\"balance\":3.5026269702e+20,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xf0df09387693690b1e00d71eabf5e98e7955cff4\",\"name\":\"ENDO.network Promo Token\",\"decimals\":\"18\",\"symbol\":\"ETP\",\"totalSupply\":\"4000000000000000000000000\",\"owner\":\"0xf8dfe0f0c640801357a33b807f2b1f0a591285b1\",\"lastUpdated\":1551841095,\"issuancesCount\":0,\"holdersCount\":105756,\"price\":false},\"balance\":1.6e+19,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359\",\"name\":\"DAI\",\"decimals\":\"18\",\"symbol\":\"DAI\",\"totalSupply\":\"92647191741080925165119451\",\"owner\":\"0x0000000000000000000000000000000000000000\",\"lastUpdated\":1525270896825,\"issuancesCount\":0,\"holdersCount\":17596,\"image\":\"https://ethplorer.io/images/dai.png\",\"description\":\"Decentralized stablecoin by MakerDAO\",\"website\":\"https://makerdao.com/\",\"twitter\":\"makerdao\",\"reddit\":\"MakerDAO\",\"ethTransfersCount\":0,\"price\":{\"rate\":0.989204564662,\"diff\":-0.89,\"diff7d\":-1.9,\"ts\":1552413785,\"marketCapUsd\":87888697.32666,\"availableSupply\":88847848.530391,\"volume24h\":22838945.200286,\"diff30d\":-0.4960108317397,\"currency\":\"USD\"}},\"balance\":9.9321134304168e+20,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2\",\"name\":\"Wrapped Ether\",\"decimals\":\"18\",\"symbol\":\"WETH\",\"totalSupply\":\"2366897734440172514209996\",\"owner\":\"0x\",\"lastUpdated\":1552413595,\"issuancesCount\":0,\"holdersCount\":36846,\"ethTransfersCount\":121745,\"price\":{\"rate\":129.716358322,\"diff\":2.58,\"diff7d\":-0.49,\"ts\":1552413787,\"marketCapUsd\":0,\"availableSupply\":null,\"volume24h\":307033.9979474,\"diff30d\":22.981780427152,\"currency\":\"USD\"}},\"balance\":1.24375e+18,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x5c1e2c3119aa5134c29c79df73d8be17266c7c2a\",\"name\":\"Shares\",\"decimals\":\"0\",\"symbol\":\"SHARE\",\"totalSupply\":\"467500000000000\",\"owner\":\"\",\"lastUpdated\":1549483567,\"issuancesCount\":0,\"holdersCount\":32,\"price\":false},\"balance\":7000000000000,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xa87ec9e0e006b90be2c4e3bba3fd17450f7c7034\",\"name\":\"Shares\",\"decimals\":\"0\",\"symbol\":\"SHARE\",\"totalSupply\":\"4465792175000000\",\"owner\":\"\",\"lastUpdated\":1549483567,\"issuancesCount\":0,\"holdersCount\":47,\"price\":false},\"balance\":7000000000000,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x90e8bea7d49ced8db79f43649e04df000a0acbfa\",\"name\":\"Shares\",\"decimals\":\"0\",\"symbol\":\"SHARE\",\"totalSupply\":\"2575700000000000\",\"owner\":\"\",\"lastUpdated\":1549483567,\"issuancesCount\":0,\"holdersCount\":40,\"price\":false},\"balance\":7000000000000,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xf5ed2dc77f0d1ea7f106ecbd1850e406adc41b51\",\"name\":\"The Ocean Token\",\"decimals\":\"18\",\"symbol\":\"OCEAN\",\"totalSupply\":\"11828625000000000000000000\",\"owner\":\"0x2d087f25aed35a02aa30d5d279269cdcd240a864\",\"lastUpdated\":1552285093,\"issuancesCount\":0,\"holdersCount\":11924,\"ethTransfersCount\":0,\"price\":false},\"balance\":7.5e+20,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x1985365e9f78359a9b6ad760e32412f4a445e862\",\"name\":\"Reputation\",\"decimals\":\"18\",\"symbol\":\"REP\",\"totalSupply\":\"11000000000000000000000000\",\"owner\":\"\",\"lastUpdated\":1552413595,\"issuancesCount\":0,\"holdersCount\":7743,\"ethTransfersCount\":0,\"price\":false},\"balance\":1.47347741e+18,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x9eec65e5b998db6845321baa915ec3338b1a469b\",\"name\":\"OnlyChain\",\"decimals\":\"18\",\"symbol\":\"Only\",\"totalSupply\":\"5000000000000000000000000000\",\"owner\":\"0x17e1bb02e9a1afa4a6e77f3b2a72bfe6768e5c5e\",\"lastUpdated\":1552408265,\"issuancesCount\":0,\"holdersCount\":53574,\"price\":false},\"balance\":2.0e+19,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xaf47ebbd460f21c2b3262726572ca8812d7143b0\",\"name\":\"Promodl\",\"decimals\":\"0\",\"symbol\":\"PMOD\",\"totalSupply\":\"550\",\"owner\":\"\",\"lastUpdated\":1552347162,\"issuancesCount\":0,\"holdersCount\":349520,\"price\":false},\"balance\":5,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xae76c84c9262cdb9abc0c2c8888e62db8e22a0bf\",\"name\":\"\",\"decimals\":\"18\",\"symbol\":\"\",\"totalSupply\":\"484627577717826353904\",\"owner\":\"\",\"lastUpdated\":1552367259,\"issuancesCount\":0,\"holdersCount\":45,\"price\":false},\"balance\":1.0e+17,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x58b6a8a3302369daec383334672404ee733ab239\",\"name\":\"Livepeer Token\",\"decimals\":\"18\",\"symbol\":\"LPT\",\"totalSupply\":\"12038524700088476160285142\",\"owner\":\"0x8573f2f5a3bd960eee3d998473e50c75cdbe6828\",\"lastUpdated\":1552413553,\"issuancesCount\":0,\"holdersCount\":2589644,\"ethTransfersCount\":0,\"price\":{\"rate\":6.56219612378,\"diff\":7.78,\"diff7d\":-8.17,\"ts\":1552413789,\"marketCapUsd\":0,\"availableSupply\":null,\"volume24h\":57201.448910541,\"diff30d\":47.578252375563,\"currency\":\"USD\"}},\"balance\":1.0e+19,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2\",\"name\":\"Maker\",\"decimals\":\"18\",\"symbol\":\"MKR\",\"totalSupply\":\"1000000000000000000000000\",\"owner\":\"0x8ee7d9235e01e6b42345120b5d270bdb763624c7\",\"lastUpdated\":1552413594,\"issuancesCount\":0,\"holdersCount\":9606,\"description\":\"Maker Token for Makerdao governance and fees.\\n\\nhttp://makerdao.com/\\nhttps://twitter.com/makerdao\\nhttps://reddit.com/r/makerdao\\nhttps://chat.makerdao.com for questions/discussion\",\"ethTransfersCount\":0,\"price\":{\"rate\":650.571299413,\"diff\":-0.72,\"diff7d\":-2.21,\"ts\":1552413783,\"marketCapUsd\":650571299.413,\"availableSupply\":1000000,\"volume24h\":1124983.3563419,\"diff30d\":42.273597267453,\"currency\":\"USD\"}},\"balance\":4.0e+16,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x393702b51cdbf577e509336d752e4058d4b2932a\",\"name\":\"Leveraged ETH 1/30\",\"decimals\":\"18\",\"symbol\":\"LETH 1/30\",\"totalSupply\":\"15378891009485283851\",\"owner\":\"0x06bf832ab7251fea03c6d4f2be954b11eb9f418e\",\"lastUpdated\":1551118558,\"issuancesCount\":0,\"holdersCount\":61,\"price\":false},\"balance\":2.1454068846653e+18,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x53b04999c1ff2d77fcdde98935bb936a67209e4c\",\"name\":\"Veil Ether\",\"decimals\":\"18\",\"symbol\":\"Veil ETH\",\"totalSupply\":\"553777261718978033682\",\"owner\":\"0x\",\"lastUpdated\":1552413201,\"issuancesCount\":0,\"holdersCount\":452,\"price\":false},\"balance\":1.1569318e+17,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x93aa10a44bce4a0ca8127bb4f12e0faf25967376\",\"name\":\"Virtual Augur Share\",\"decimals\":\"18\",\"symbol\":\"VSHARE\",\"totalSupply\":\"179100000000000\",\"owner\":\"\",\"lastUpdated\":1550334801,\"issuancesCount\":0,\"holdersCount\":6,\"price\":false},\"balance\":15000000000000,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xc59bee089a43c8ac524e48838d55eaf4e900bd5f\",\"name\":\"Virtual Augur Share\",\"decimals\":\"18\",\"symbol\":\"VSHARE\",\"totalSupply\":\"205000000000000\",\"owner\":\"\",\"lastUpdated\":1550371430,\"issuancesCount\":0,\"holdersCount\":4,\"price\":false},\"balance\":7000000000000,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0x3dc64ea1049d45f0c75d205898bd0096470c07d2\",\"name\":\"Balance\",\"decimals\":\"0\",\"symbol\":\"BAL\",\"totalSupply\":\"4\",\"owner\":\"\",\"lastUpdated\":1549943461,\"issuancesCount\":0,\"holdersCount\":4,\"price\":false},\"balance\":1,\"totalIn\":0,\"totalOut\":0},{\"tokenInfo\":{\"address\":\"0xc3761eb917cd790b30dad99f6cc5b4ff93c4f9ea\",\"name\":\"ERC20\",\"decimals\":\"18\",\"symbol\":\"ERC20\",\"totalSupply\":\"13000000000000000000000000000\",\"owner\":\"\",\"lastUpdated\":1531744572101,\"issuancesCount\":0,\"holdersCount\":50738,\"image\":\"https://ethplorer.io/images/belance.png\",\"description\":\"Belance is a large unique blockchain platform which combines many opportunities and connects everyone in the blockchain world.\",\"website\":\"https://belance.io\",\"facebook\":\"erc20project\",\"twitter\":\"erc20_\",\"ethTransfersCount\":0,\"price\":{\"rate\":0.0354292317801,\"diff\":3,\"diff7d\":-3.1,\"ts\":1552413784,\"marketCapUsd\":248004.6224607,\"availableSupply\":7000000,\"volume24h\":35129.102472301,\"diff30d\":-74.694263492347,\"currency\":\"USD\"}},\"balance\":9.9e+17,\"totalIn\":0,\"totalOut\":0}]}"

struct AddressInfoResponse: Decodable {
    let address: String?
    let ETH: ETHResponse?
    let countTxs: UInt64?
    let tokens: [TokenInfoWrapperResponse]?
}

struct ETHResponse: Codable {
    let balance: Double?
    
    private enum CodingKeys: String, CodingKey {
        case balance = "balance"
    }
}

struct TokenInfoWrapperResponse: Codable {
    let tokenInfo: TokenInfoResponse?
    let balance: Double?
    
    private enum CodingKeys: String, CodingKey {
        case tokenInfo = "tokenInfo"
        case balance   = "balance"
    }
}

struct TokenInfoResponse: Codable {
    let address: String?
    let name: String?
    let decimals: String?
    let symbol: String?
    let totalSupply: String?
    let owner: String?
    let lastUpdated: UInt64?
    let issuancesCount: UInt64?
    let holdersCount: UInt64?
    let ethTransfersCount: UInt64?
    let price: PriceResponse?
    
    private enum CodingKeys: String, CodingKey {
        case address           = "address"
        case name              = "name"
        case decimals          = "decimals"
        case symbol            = "symbol"
        case totalSupply       = "totalSupply"
        case owner             = "owner"
        case lastUpdated       = "lastUpdated"
        case issuancesCount    = "issuancesCount"
        case holdersCount      = "holdersCount"
        case ethTransfersCount = "ethTransfersCount"
        case price             = "price"
    }
    
    init(from decoder: Decoder) throws {
        print("init called")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try? container.decode(String.self, forKey: .address)
        name = try? container.decode(String.self, forKey: .name)
        decimals = try? container.decode(String.self, forKey: .decimals)
        symbol = try? container.decode(String.self, forKey: .symbol)
        totalSupply = try? container.decode(String.self, forKey: .totalSupply)
        owner = try? container.decode(String.self, forKey: .owner)
        lastUpdated = try? container.decode(UInt64.self, forKey: .lastUpdated)
        issuancesCount = try? container.decode(UInt64.self, forKey: .issuancesCount)
        holdersCount = try? container.decode(UInt64.self, forKey: .holdersCount)
        ethTransfersCount = try? container.decode(UInt64.self, forKey: .ethTransfersCount)
        
        // Handle possible boolean value in price field
        do {
            print("trying to decode price bool")
            try container.decode(Bool.self, forKey: .price)
            print("decoded price bool")
            price = nil
        } catch {
            print("price is not a bool")
            price = try? container.decode(PriceResponse.self, forKey: .price)
        }
    }
}

struct PriceResponse: Codable {
    let rate: Double?
    let diff: Double?
    let diff7d: Double?
    let ts: UInt64?
    let marketCapUsd: Double?
    let availableSupply: Double?
    let volume24h: Double?
    let diff30d: Double?
    let currency: String?
    
    private enum CodingKeys: String, CodingKey {
        case rate            = "rate"
        case diff            = "diff"
        case diff7d          = "diff7d"
        case ts              = "ts"
        case marketCapUsd    = "marketCapUsd"
        case availableSupply = "availableSupply"
        case volume24h       = "volume24h"
        case diff30d         = "diff30d"
        case currency        = "currency"
    }
}

let data = ethplorerJSON.data(using: .utf8)!
do {
    let addressInfoResponse = try JSONDecoder().decode(AddressInfoResponse.self, from: data)
    print(addressInfoResponse)
} catch {
    print(error)
}
