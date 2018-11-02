pragma solidity ^0.4.24;

/**
 * This contract uses the 0xcert.org implementation of the ERC-721 NFT standard for the
 * Ethereum Blockchain.
 */
import "../tokens/NFTokenMetadata.sol";
import "@0xcert/ethereum-utils/contracts/ownership/Ownable.sol";


/**
 * @title Audiogram
 * The purpose of this smart contract is to create an easy way to store music
 * and audio data on the blockchain. This contract is ERC-721 enabled so that
 * owners of the token will also own the corresponding audio associated with it.
 */
contract Audiogram is NFTokenMetadata, Ownable {

	/**
	 * the contstuctor function creates the token and assigns the name and symbol.
	 */
	constructor(string _name, string _symbol) public {
		nftName = _name;
		nftSymbol = _symbol;
	}

	/**
	 * @dev mint creates a new NFT to the owner.
	 * @param _owner is the address that owns the contract.
	 * @param _id is the identification of the token.
	 */
	function mint(address _owner, uint256 _id) onlyOwner external {
		super._mint(_owner, _id);
	}

	/**
	 * @dev burn destroys the token.
	 * @param _owner is the address that owns the contract.
	 * @param _id is the identification of the token.
	 */
	function burn(address _owner, uint256 _id) onlyOwner external {
		super._burn(_owner, _id);
	}
}