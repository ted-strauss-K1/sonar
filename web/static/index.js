import Vue from "vue";
import VueMaterial from "vue-material";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import "es6-promise/auto";
import "vue-material/dist/vue-material.css";

Vue.use(VueMaterial);
Vue.material.registerTheme("default", {
  primary: { color: "grey", hue: 900 },
  accent: { color: "red", hue: "A200" },
  warn: { color: "red", hue: "A200" },
  background: "grey"
});

router.afterEach((to, from) => {
  _paq.push(["setReferrerUrl", from.path]);
  _paq.push(["setCustomUrl", to.path]);
  _paq.push(["setDocumentTitle", window.document.title]);
  // _paq.push(["deleteCustomVariables", "page"]);
  _paq.push(["setGenerationTimeMs", 0]);
  _paq.push(["trackPageView"]);
});

new Vue({ el: "#app", router, store, ...App });

store.dispatch("GEOLOCATION");
