<template>
    <md-whiteframe>
        <div class="progress">
          <div :style="{ width: playerRead + '%' }" class="progress-bar md-theme-default"/>
        </div>
        <md-button @click.native="$router.push(`/events/${currentEvent.id}`)" class="md-fab md-mini get-details" md-fab-trigger>
          <md-icon>event</md-icon>
        </md-button>
      <md-layout class="nowrap">
        <div class="player_wrapper">
          <Player ref="player"/>
        </div>
        <md-layout class="event-details">
          <md-layout class="flex-center"v-if="currentEvent">
            <md-button class="artist-display">{{ currentEvent.artist }}</md-button>
          </md-layout>
          <md-layout class="flex-center nowrap">
            <md-button @click.native="previousEvent" class="md-icon-button"><md-icon class="md-primary">skip_previous</md-icon></md-button>
            <md-button v-if="playerState == 1 || playerState == 3" @click.native="pause" class="md-icon-button"><md-icon class="md-primary">pause</md-icon></md-button>
            <md-button v-else @click.native="play" class="md-icon-button"><md-icon class="md-primary">play_arrow</md-icon></md-button>
            <md-button @click.native="nextEvent" class="md-icon-button"><md-icon class="md-primary">skip_next</md-icon></md-button>
          </md-layout>

          <md-layout md-hide-medium class="flex-center nowrap">
            <md-button @click.native="previousDay" class="md-icon-button"><md-icon>keyboard_arrow_left</md-icon></md-button>
            <md-button>{{ currentDate }}</md-button>
            <md-button @click.native="nextDay" class="md-icon-button"><md-icon>keyboard_arrow_right</md-icon></md-button>
          </md-layout>
        </md-layout>
      </md-layout>
    </md-whiteframe>
</template>

<script>
  import Player from "./Player.vue";

  export default {
    components: { Player },
    computed: {
      currentEvent() {
        return this.$store.getters.currentEvent;
      },
      currentDate() {
        return this.$store.getters.currentDate;
      },
      playerState() {
        return this.$store.state.playerState;
      },
      playerRead() {
        return this.$store.state.playerRead;
      }
    },
    methods : { 
      previousDay() {
        this.$store.dispatch("PREVIOUS_DAY");
      },
      nextDay() {
        this.$store.dispatch("NEXT_DAY");
      },
      previousEvent() {
        this.$store.dispatch("PREVIOUS_EVENT");
      },
      nextEvent() {
        this.$store.dispatch("NEXT_EVENT");
      },
      play() {
        this.$refs.player.play();
      },
      pause() {
        this.$refs.player.pause();
      }
    }
  }
</script>

<style>

  .progress {
    background-color: black;
    height: 3px;
  }
  .progress-bar {
    background-color: #FF5252;
    transition: width .3s ease-in;
    height: 3px;
  }
  .player-footer {
    background-color: #333;
  }

  .artist-display {
    padding: 0 !important;
    margin-bottom: 0 !important;
  }

  .get-details {
    position: absolute !important;
    top: -30px;
    right: 1em;
  }

  .event-details {
    justify-content: space-between !important;
    align-items: center;
    height: 90px;
  }

  @media (max-width: 480px) {
    .event-details {
      flex-direction: column !important;
    }

    .artist-display {
      /*margin-top: .2em;*/
      /*padding-left: .5em;
      padding-right: .5em;*/
      width: 140px;
      line-height: 70px;
      /*text-align: center;*/
      /*min-width: 0;*/
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
      /*flex: 0 1 auto !important;*/
    }
  }
</style>
