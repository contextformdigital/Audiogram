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
		uint256 id;
		uint256 price;
	}

	/**
	 * @dev Media stores consumer information.
	 */
	struct Media {
		address creator;
		string title;
		uint256 price;
		address[] consumer;
	}

	/**
	 * @dev Creator struct of the creator media list.
	 */
	struct Creator {
		string[] creatorMediaList;
	}

	/**
	 * @dev Conssumer struct of the consumer list.
	 */
	struct Consumer {
		string[] consumerMediaList;
	}

	string public ipfsHash;
	string[] public allMedia;
	SongMetadata[] public songs;
	mapping(address => uint256) public wallet;
	mapping(address => SongMetadata[]) public submittedSongs;
	mapping(string => Media) mediaStructs;
	mapping(address => Creator) creatorStructs;
	mapping(address => Consumer) consumerStructs;




	/**
	 * @dev submitMetadata.
	 * @param _title Song title.
	 * @param _artist Name of the artist.
	 * @param _album is the Album name.
	 * @param _year is the year the album is released.
	 * @param _id is the for the metadata and corresponding NFT.
	 */
	function submitMetadata(string _title, string _artist, string _album, uint256 _year, uint256 _id, uint256 _price) public {
		submittedSongs[msg.sender].push(SongMetadata({
			title: _title,
			artist: _artist,
			album: _album,
			year: _year,
			id: _id,
			price: _price
		}));
	}

	/**
	 * @dev getMetadata returns the data from the struct
	 * @param _id is the corresponding metadata and NFT identification.
	 */
	function getMetadata(uint256 _id) public view returns (string, string, string, uint256, uint256) {
		return (submittedSongs[msg.sender][_id].title,
				submittedSongs[msg.sender][_id].artist,
				submittedSongs[msg.sender][_id].album,
				submittedSongs[msg.sender][_id].year,
				submittedSongs[msg.sender][_id].price);
	}

	/**
	 * @dev buy functionality
	 * @param hash is the output of the submitMetadata function.
	 */
	function buy(string hash) payable public returns (bool) {
		uint256 amount = mediaStructs[hash].price;
		address receiver = mediaStructs[hash].creator;
		if (wallet[msg.sender] < mediaStructs[hash].price) return false;
		wallet[msg.sender] -= amount;
		wallet[receiver] += amount;
		emit Transfer(msg.sender, receiver, amount);
		consumerStructs[msg.sender].consumerMediaList.push(hash);
		mediaStructs[hash].consumer.push(msg.sender);
		return true;
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