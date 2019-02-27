//
//  CDP.swift
//  Balance
//
//  Created by Richard Burton on 20/02/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation

struct CDP {
    let identifier:Int?
    let ratio:Double?
    let pip:Double?
    let art:Double?
    let ink:Double?
    let liqPrice:Double?
}

//    "tab": 42249.60231457469,
//    "time": 2019-01-31T14:34:47.000Z,
//    "id": 14165,
//    "ratio": 281.664015430498,
//    "lad": 0x507c0d38456a75b56d938228f0eb8Df00E2A2f15,
//    "art": 15000,
//    "deleted": 0,
//    "arg": <null>,
//    "pip": 145.635,
//    "ink": 278.7336414172244,
//    "pep": 645.17,
//    "timestamp": 1548945287000,
//    "ire": 14825.62108276614,
//    "per": 1.040800462956618,
//    "act": give,
//    "liq_price": 77.55783061819776]]

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

//https://github.com/bokkypoobah/MakerDAOSaiContractAudit/blob/master/audit/checkComponents/saiTub.sol#L634


//[["block": 7154155,
//    "tab": 42249.60231457469,
//    "time": 2019-01-31T14:34:47.000Z,
//    "id": 14165,
//    "ratio": 281.664015430498,
//    "lad": 0x507c0d38456a75b56d938228f0eb8Df00E2A2f15,
//    "art": 15000,
//    "deleted": 0,
//    "arg": <null>,
//    "pip": 145.635,
//    "ink": 278.7336414172244,
//    "pep": 645.17,
//    "timestamp": 1548945287000,
//    "ire": 14825.62108276614,
//    "per": 1.040800462956618,
//    "act": give,
//    "liq_price": 77.55783061819776]]

//guard let url = URL(string: "https://mkr.tools/api/v1/cdp/14165") else {return}// a CDP
