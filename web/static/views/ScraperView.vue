<template>
  <md-card>
    <md-button @click.native="$router.push('map')" class="md-icon-button"><md-icon class="md-primary">arrow_back</md-icon></md-button>
    <md-button @click.native="scrape()">Scrape</md-button>
  </md-card>
</template>

<script>

export default {
  // props: ['id'],
  computed: {
    // currentEvent() {
    //   return this.$store.state.events[this.id];
    // },
    // currentDate() {
    //   if (this.currentEvent) {
    //     const stubDate = new Date();
    //     const utc_date = this.currentEvent.utc_date;
    //     const date = new Date(utc_date * 1000);
    //     const str = date.toDateString();
    //     return `${date.toDateString()} - ${date.toTimeString().substr(0, 5)}`;
    //   } else {
    //     return "";
    //   }
    // },
  },
  methods: {
    // trackOutLink(url) {
    //   _paq.push(["trackLink", url, "link"]);
    // },
    // fetchData() {
    //   this.$store.dispatch("FETCH_EVENTS", { ids: [this.id] }).then(() => {
    //     this.loading = false;
    //   })
    // }
    scrape() {
      this.$store.dispatch("SCRAPE");
    }
  },
  data() {
    return {
      // loading: true
    }
  },
  // watch: {
  //   "$route": "fetchData"
  // },
  // created() {
  //   this.fetchData()
  // }
}
</script>

<style>
</style>
