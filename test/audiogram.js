const Audiogram = artifacts.require("./Audiogram.sol");

contract("Audiogram Contract", accounts => {

	let contract;
	let [one, two] = accounts;
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
		assert.strictEqual(owner, one);
	});

	it('Submits and gets song metadata', async () => {
		hashArr.push(await contract.submitMetadata(artist, song, album, year, id, price, { from: one, gas: 200000 }));
		let data = await contract.getMetadata(id);
		assert.strictEqual(data[0], artist);
		assert.strictEqual(data[1], song);
		assert.strictEqual(data[2], album);
		assert.strictEqual(data[3].toString(), year.toString());
		assert.strictEqual(data[4].toString(), '1');
	});

	it('mints new token', async () => {
		await contract.mint(one, 1, { from: one });
		const newBalance = await contract.balanceOf(one);
		assert.strictEqual(newBalance.toString(), '1');
	});

	it('buys a token', async () => {
		hashArr.push(await contract.submitMetadata(artist, song, album, year, id, price, { from: one, gas: 200000 }));
		const txHash = hashArr[0]['tx'];
		let output = await contract.buy(txHash, { from: one, gas: 200000 });
		assert.strictEqual(typeof output, 'object');
	});

});