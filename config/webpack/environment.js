const vueConfig = require('./vue_config')
const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
// const vue = require('./loaders/vue')

// environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
// environment.loaders.prepend('vue', vue)

environment.config.merge(vueConfig);
module.exports = environment
