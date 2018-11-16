const Audiogram = artifacts.require('Audiogram');

module.exports = ((deployer) => {
	deployer.deploy(Audiogram, 'Audiogram', 'AUDIO');
})