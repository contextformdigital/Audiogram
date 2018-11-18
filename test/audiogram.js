const Audiogram = artifacts.require("./Audiogram.sol");

contract("Audiogram Contract", accounts => {

	let contract;
	let [account0, account1] = accounts;
	let tokenName = 'Audiogram';
	let tokenSymbol = 'AUDIO';
	let artist = 'New Artist';
	let song = 'New Song';
	let album = 'New Album';
	let year = 2018;
	let id = 0;
	let price = 1.29;
	let hashArr = [];

	before(async () => {
		contract = await Audiogram.deployed();
	});

	it("verifies owner of conract", async () => {
		const owner = await contract.owner.call();
		assert.strictEqual(owner, account0);
	});

	it('verifies the name and symbol of the contract', async () => {
		const name = await contract.name.call();
		const symbol = await contract.symbol.call();
		assert.strictEqual(name, tokenName);
		assert.strictEqual(symbol, tokenSymbol);
	});

	it('Submits and gets song metadata', async () => {
		hashArr.push(await contract.submitMetadata(artist, song, album, year, id, price, { from: account0, gas: 200000 }));
		let data = await contract.getMetadata(id);
		assert.strictEqual(data[0], artist);
		assert.strictEqual(data[1], song);
		assert.strictEqual(data[2], album);
		assert.strictEqual(data[3].toString(), year.toString());
		assert.strictEqual(data[4].toString(), '1');
	});

	it('mints NFT to owner', async () => {
		await contract.mint(account0, 1, { from: account0 });
		const newBalance = await contract.balanceOf(account0);
		assert.strictEqual(newBalance.toString(), '1');
	});

	it('transfer NFT to new wallet address', async () => {
		await contract.safeTransferFrom(account0, account1, 1, { from: account0 });
		const balanceOne = await contract.balanceOf(account0);
		const balanceTwo = await contract.balanceOf(account1);
		assert.strictEqual(balanceOne.toString(), '0');
		assert.strictEqual(balanceTwo.toString(), '1');
	});

	it('transfers the NFT back to the original address', async () => {
		await contract.safeTransferFrom(account1, account0, 1, { from: account1 });
		const balanceOne = await contract.balanceOf(account0);
		const balanceTwo = await contract.balanceOf(account1);
		assert.strictEqual(balanceOne.toString(), '1');
		assert.strictEqual(balanceTwo.toString(), '0');
	});

	it('buys a token', async () => {
		hashArr.push(await contract.submitMetadata(artist, song, album, year, id, price, { from: account0, gas: 200000 }));
		const txHash = hashArr[0]['tx'];
		let output = await contract.buy(txHash, { from: account0, gas: 200000 });
		assert.strictEqual(typeof output, 'object');
	});

});