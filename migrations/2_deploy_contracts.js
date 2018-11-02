const Audiogram = artifacts.require('Audiogram');

let name = 'Audiogram';
let symbol = 'AUDIO';

module.exports = ((deployer) => {
	deployer.deploy(Audiogram, name, symbol);
})