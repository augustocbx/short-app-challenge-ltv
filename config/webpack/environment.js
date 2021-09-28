const { environment } = require('@rails/webpacker')
const vueConfig = require('./vue_config')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

environment.config.merge(vueConfig);
module.exports = environment
