const Audiogram = artifacts.require("./Audiogram.sol");

contract("Audiogram Contract", accounts => {

	let contract;
	let [one, two] = accounts;

	before(async () => {
		contract = await Audiogram.deployed();
	});

	it("verifies owner of conract", async () => {
		const owner = await contract.owner.call();
		assert.strictEqual(owner, one);
	});

});