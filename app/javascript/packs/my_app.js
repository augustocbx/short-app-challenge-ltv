import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import VueResource from 'vue-resource'
import BootstrapVue from 'bootstrap-vue'
import axios from 'axios'

Vue.use(VueResource)
Vue.use(TurbolinksAdapter)
Vue.use(BootstrapVue)

document.addEventListener('turbolinks:load', () => {
    var element = document.getElementById("app")

    if (element != null) {

        new Vue({
            el: '#app',
            data: {
                counter: 1,
                url: '',
                urls: [],
                showDismissibleAlert: false,
                errorMsg: ''
            },
            mounted: function (){
                this.getTopURLs();
            },
            methods: {
                getTopURLs: function (){
                    axios.get('http://localhost:3000/short_urls.json').then((data) => {
                        this.urls = data.data.urls;
                    });
                }
            }
        })
    }
});