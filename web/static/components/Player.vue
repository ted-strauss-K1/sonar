<style>

.player {
    position: relative;
    padding-bottom: 56.25%;
    height: 0;
}

.player iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100% !important;
}

</style>

<template>

<div class="player"/>

</template>

<script>

import Youtube from "youtube-wrapper";

Youtube.autoLoadYouTubeAPI();

let hasPlayed = false;

export default {
  computed: {
    currentEvent() {
      return this.$store.getters.currentEvent;
    }
  },
  methods: {
    updateMedia(ytid) {
      if (hasPlayed) {
        this.$store.commit("PLAYER_READ", 0);
        this.player.loadVideoById(ytid)
      } else {
        this.player.cueVideoById(ytid);
      };
    },
    onStateChange(state) {
      this.$store.commit("PLAYER_STATE", state.data);
      if (state.data === 0) {
        this.$store.commit("PLAYER_READ", 0);
        this.$store.dispatch("NEXT_EVENT");
      } else if (state.data === 1) {
        if (!hasPlayed) this.interval = setInterval(() => {
          const played = this.player.getCurrentTime() / this.player.getDuration();
          this.$store.commit("PLAYER_READ", played * 100);
        }, 1000);
        hasPlayed = true;
      }
    },
    play() {
      this.player.playVideo();
    },
    pause() {
      this.player.pauseVideo();
    }
  },
  watch: {
    currentEvent(event) {
      this.updateMedia(event.ytid);
    }
  },
  mounted() {
    this.player = new Youtube.Player(
      this.$el.appendChild(document.createElement("div")),
      { playerVars: { controls: 0, modestbranding: 1, disablekb: 1, iv_load_policy: 3 } }
    );
    this.player.on("onStateChange", this.onStateChange);
    if (this.currentEvent) this.updateMedia(this.currentEvent.ytid);
  },
  beforeDestroy() {
    clearInterval(this.interval);
    this.player.removeAllListeners();
    this.player.destroy();
  }
};

</script>
