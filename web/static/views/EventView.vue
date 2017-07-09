<template>
  <md-layout md-align="center" v-if="loading">
    <md-spinner  md-indeterminate class="md-accent"></md-spinner>
  </md-layout>
  <md-card v-else>
    <md-button @click.native="$router.go(-1)" class="md-icon-button"><md-icon class="md-primary">arrow_back</md-icon></md-button>
    <div v-if="currentEvent">
      <md-card-header>
        <div class="md-subhead">{{ currentDate }}</div>
        <div class="md-display-2">{{ currentEvent.artist }}</div>
        <div class="md-title">{{ currentEvent.venue }}</div>
      </md-card-header>
      <md-card-content>
        <div class="md-body">{{ currentEvent.price }}</div>
        <md-list>
         <md-list-item v-if="currentEvent.url_facebook" @click.native="trackOutLink(currentEvent.facebook)" target="_blank" :href="currentEvent.url_facebook">
           <md-icon :md-src="require('../assets/facebook.svg')"></md-icon> <span>Facebook event</span>
         </md-list-item>
         <md-list-item v-if="currentEvent.url_ticket" @click.native="trackOutLink(currentEvent.url_ticket)" target="_blank" :href="currentEvent.url_ticket">
           <md-icon>attach_money</md-icon> <span>Buy tickets</span>
         </md-list-item>
       </md-list>
      </md-card-content>
      
    </div>
  </md-card>
</template>

<script>

export default {
  props: ['id'],
  computed: {
    currentEvent() {
      return this.$store.state.events[this.id];
    },
    currentDate() {
      if (this.currentEvent) {
        const stubDate = new Date();
        const utc_date = this.currentEvent.utc_date;
        const date = new Date(utc_date * 1000);
        const str = date.toDateString();
        return `${date.toDateString()} - ${date.toTimeString().substr(0, 5)}`;
      } else {
        return "";
      }
    },
  },
  methods: {
    trackOutLink(url) {
      _paq.push(["trackLink", url, "link"]);
    },
    fetchData() {
      this.$store.dispatch("FETCH_EVENTS", { ids: [this.id] }).then(() => {
        this.loading = false;
      })
    }
  },
  data() {
    return {
      loading: true
    }
  },
  watch: {
    "$route": "fetchData"
  },
  created() {
    this.fetchData()
  }
}
</script>

<style>
</style>
