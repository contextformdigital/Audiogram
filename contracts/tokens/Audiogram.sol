pragma solidity ^0.4.24;

/**
 * This contract uses the 0xcert.org implementation of the ERC-721 NFT standard for the
 * Ethereum Blockchain.
 * https://github.com/0xcert/ethereum-erc721
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
	 * @dev Metadata struct that contains artist and song metadata.
	 */
	struct SongMetadata {
		string title;
		string artist;
		string album;
		uint256 year;
		string songHash;
		uint256 id;
	}

	/**
	 * Assign Metadata struct to public variable songs.
	 */
	SongMetadata[] public songs;
	mapping(address => SongMetadata[]) public submittedSongs;

	/**
	 * @dev submitMetadata.
	 * @param _title Song title.
	 * @param _artist Name of the artist.
	 * @param _album is the Album name.
	 * @param _year is the year the album is released.
	 * @param _songHash is the hash of the song stored in IPFS.
	 */
	function submitMetadata(string _title, string _artist, string _album, uint256 _year, string _songHash, uint256 _id) public {
		submittedSongs[msg.sender].push(SongMetadata({
			title: _title,
			artist: _artist,
			album: _album,
			year: _year,
			songHash: _songHash,
			id: _id
		}));
	}

	// test if submit function works
	// THIS FUNCTION IS ONLY FOR TESTING!
	function getMetadata(uint256 _id) public view returns (string, string, string, uint256) {
		return {
			title: submittedSongs[msg.sender][_id].title,
			artist: submittedSongs[msg.sender][_id].artist,
			album: submittedSongs[msg.sender][_id].album,
			year: submittedSongs[msg.sender][_id].year}
		};
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