pragma solidity >=0.6.0 <0.7.0;
//SPDX-License-Identifier: MIT

//import "hardhat/console.sol";
import "./ERC722/ERC722.sol";
import "./AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

//GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract IjazaCert is AccessControl, ERC722, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _IjazaID;

    constructor() public ERC722("Ijazat qiraat", "IQC") {
        _setBaseURI("https://ipfs.io/ipfs/"); // todo change url
    }
    
    event IssueIjazaEvent(address indexed to, address indexed parentCertId, uint256 indexed id);

    // we only have 10 Quaraat
    // forked from crypto_ijazates
    struct Ijaza {
        uint256 qiraa;
        // The timestamp from the block when this is created.
        uint64 issueTime;
        // The ID of the parents of this cert, set to 0 for genesis cert.
        // Note that using 32-bit unsigned integers limits us to a "mere"
        // 4 billion certificate. This number might seem small until you realize
        // that Ethereum currently has a limit of about 500 million
        // transactions per year! So, this definitely won't be a problem
        // for several years (even as Ethereum learns to scale).
        uint32 parentCertId;
        // The "generation number" of this cert. certifcated minted by the CK contract
        // for sale are called "gen0" and have a generation number of 0. The
        // generation number of all other certificate is the larger of its parent, plus one.
        // (i.e. max(matron.generation, sire.generation) + 1)
        uint16 generation;
    }
    Ijaza[] ijazat;

    // todo - contract owner or parentCertId owner should be calling this function
    function issueIjaza(
        address to,
        string memory tokenURI,
        uint256 parentCertId
    ) public returns (uint256) {
        Ijaza memory _issuerIjaza = ijazat[parentCertId];
        require(
            _isOwner(msg.sender, parentCertId),
            "issuer must have an Ijaza first"
        );

        Ijaza memory _ijaza =
            Ijaza({
                qiraa: _issuerIjaza.qiraa,
                issueTime: uint64(now),
                parentCertId: uint32(parentCertId),
                generation: uint16(_issuerIjaza.generation + 1)
            });
        ijazat.push(_ijaza);
        uint256 id = _IjazaID.current();
        _mint(to, id);
        _setTokenURI(id, tokenURI);
        _IjazaID.increment();

        if(parentCertId != 0){
          emit IssueIjazaEvent(to, parentCertId,  id);
        }
        
        return id;
    }

    // TODO - we dont need to bootstrap Ijaza, the parentCertId and Owner can issue an Ijaza
    // create an Ijaza and transfers it to 'to' address
    function bootstrapIjaza(
        address to,
        string memory tokenURI,
        uint256 qiraa
    ) public onlyCLevel() returns (uint256) { 
        Ijaza memory _ijaza =
            Ijaza({
                qiraa: qiraa,
                issueTime: uint64(now),
                parentCertId: uint32(0),
                generation: uint16(0)
            });
        ijazat.push(_ijaza);
        uint256 id = _IjazaID.current();
        _mint(to, id);
        _setTokenURI(id, tokenURI);
        _IjazaID.increment();
        return id;
    }

    /// @notice Returns all the relevant information about a specific Ijaza.
    /// @param _id The ID of the Ijaza of interest.
    function getIjaza(uint256 _id)
        external
        view
        returns (
            uint256 qiraa,
            uint256 issueTime,
            uint256 generation,
            uint256 parentCertId
        )
    {
        Ijaza storage _ijaza = ijazat[_id];
        issueTime = uint256(_ijaza.issueTime);
        parentCertId = uint256(_ijaza.parentCertId);
        generation = uint256(_ijaza.generation);
        qiraa = _ijaza.qiraa;
    }
}
