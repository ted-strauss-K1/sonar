<template>
  <md-layout md-column class="fill-screen nowrap container">
    <md-whiteframe class="hide-large">
      <md-toolbar class="md-dense">
        <!--
        <md-button class="md-icon-button" @click.native="toggleLeftSidenav">
          <md-icon>menu</md-icon>
        </md-button>
        -->
        <h2 class="md-title" style="flex: 1">Sonar</h2>
        <md-button @click.native="previousDay" class="md-icon-button"><md-icon>keyboard_arrow_left</md-icon></md-button>
        {{ currentDate }}
        <md-button @click.native="nextDay" class="md-icon-button"><md-icon>keyboard_arrow_right</md-icon></md-button>
      </md-toolbar>
    </md-whiteframe>
    <!--
    <md-sidenav class="main-sidebar md-left md-fixed" ref="leftSidenav">
      <md-toolbar class="md-large">
        <div class="md-toolbar-container">
          <img class="toolbar-title" src="~assets/sonar.png" alt="sonar">
        </div>
      </md-toolbar>
      <md-list>
        <md-list-item @click.native="nav('/map')">
          <md-icon>map</md-icon> <span>Map</span>
        </md-list-item>
      </md-list>
    </md-sidenav>
    -->
    <transition name="slide-fade" mode="out-in">
      <keep-alive>
        <router-view :style="{flex: '1 1 auto'}"/>
      </keep-alive>
    </transition>
    <dock />
  </md-layout>
</template>

<script>
  import Dock from "./components/Dock.vue";

  export default {
    components: { Dock },
    computed: {
      currentEvent() {
        return this.$store.getters.currentEvent;
      },
      currentDate() {
        return this.$store.getters.currentDate;
      }
    },
    methods: {
      toggleLeftSidenav() {
        this.$refs.leftSidenav.toggle();
      },
      nav(route) {
        this.$refs.leftSidenav.close();
        this.$router.push(route);
      },
      previousDay() {
        this.$store.dispatch("PREVIOUS_DAY");
      },
      nextDay() {
        this.$store.dispatch("NEXT_DAY");
      }
    },
    mounted() {
      document.onkeyup = event => {
        switch (event.keyCode) {
          case 37:
            this.$store.dispatch("PREVIOUS_EVENT");
            break;
          case 39:
            this.$store.dispatch("NEXT_EVENT");
            break;
        }
      };
    }
  };

</script>

<style>
  .map-tab {
    padding: 0 !important;
    flex: 1 1 auto;
    display: flex;
  }

  .nowrap {
    flex-wrap: nowrap !important;
  }

  @media (min-width: 1265px){
    .container {
      /* padding-left: 280px; */
    }

    .main-sidebar.md-sidenav .md-sidenav-content {
      top: 0;
      pointer-events: auto;
      transform: translateZ(0) !important;
      box-shadow: 0 1px 5px rgba(0,0,0,.2), 0 2px 2px rgba(0,0,0,.14), 0 3px 1px -2px rgba(0,0,0,.12);
    }

    .hide-large {
      display: none !important;
    }
  }
  .main-sidebar.md-sidenav .md-sidenav-content {
    width: 280px;
    display: -ms-flexbox;
    display: flex;
    -ms-flex-flow: column;
    flex-flow: column;
    overflow: hidden;
  }


  /*.flexys {
    flex: 1 1 auto;
    display: flex;
  }*/
  .player_wrapper {
    flex: 0 0 auto;
    width: 160px;
    height: 90px;
  }

  .toolbar-title {
    margin-top: 4em;
  }
  /*body {
    margin: 0;
    padding: 0;
    font-family: "Open Sans", "lucida grande", "Segoe UI", arial, verdana, "lucida sans unicode", tahoma, sans-serif;
  }*/
  
  .fill-screen {
    width: 100vw;
    height: 100vh;
    overflow: hidden;
  }
  /*
  .header {
    flex: 0 1 auto;
    box-shadow: 0 6px 10px 0 rgba(0, 0, 0, .14), 0 1px 18px 0 rgba(0, 0, 0, .12), 0 3px 5px -1px rgba(0, 0, 0, .2);
    z-index: 1;
    background: #111;
  }
  
  .actions {
    display: block;
    padding: .5rem;
  }
  
  @media screen and (min-width: 740px) {
    .player-container {
      max-width: 400px;
      margin: auto;
    }
  }
  
  .finder-container {
    display: flex;
    flex: 1 1 auto;
  }
  
  .date {
    color: white;
    font-family: sans-serif;
    margin-left: 0.5rem;
  }*/
  .slide-fade-enter-active {
    transition: all .2s ease;
  }
  .slide-fade-leave-active {
    transition: all .2s cubic-bezier(1.0, 0.5, 0.8, 1.0);
  }
  .slide-fade-enter, .slide-fade-leave-to
  /* .slide-fade-leave-active for <2.1.8 */ {
    transform: translateX(10px);
    opacity: 0;
  }
</style>