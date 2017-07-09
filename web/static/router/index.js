import Vue from "vue";
import Router from "vue-router";

Vue.use(Router);

const MapView = resolve => require(["../views/MapView.vue"], resolve);
const EventView = resolve => require(["../views/EventView.vue"], resolve);
const ScraperView = resolve => require(["../views/ScraperView.vue"], resolve);

export default new Router({
  mode: "history",
  scrollBehavior: () => ({ y: 0 }),
  routes: [
    { path: "/map", component: MapView },
    { path: "/events/:id", component: EventView, props: true },
    { path: "/scraper", component: ScraperView },
    { path: "/", redirect: "/map" }
  ]
});
