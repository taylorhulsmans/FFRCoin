module.exports = {
	devServer: {
		proxy: {
			'/api': {
        target: 'http://54.149.158.15'
			}
		}
	}
}
