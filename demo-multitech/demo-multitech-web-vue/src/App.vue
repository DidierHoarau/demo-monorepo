<template>
  <div class="container" id="app">
    <h1>Demo Multi Tech v1</h1>

    <button v-on:click="refresh" type="button" class="btn btn-secondary">Refresh</button>

    <div class="row">
      <div class="col-sm-6 col-md-4 col-lg-3" v-for="petType in petTypes" :key="petType.name">
        <div class="card card-pet">
          <div class="card-body">
            <h5 class="card-title">{{ petType.name }}</h5>
            <p>{{ petType.message }}</p>
          </div>
        </div>
      </div>
    </div>

    <h6>Comments (From: {{ comments.origin }})</h6>

    <div class="input-group mb-3">
      <input
        v-model="commentInput"
        type="text"
        class="form-control"
        placeholder="New comment"
        aria-label="New comment"
        aria-describedby="button-addon2"
      >
      <div class="input-group-append">
        <button
          v-on:click="postComment"
          class="btn btn-outline-secondary"
          type="button"
          id="button-addon2"
        >Send</button>
      </div>
    </div>

    <div
      class="alert alert-secondary"
      role="alert"
      v-for="comment in comments.items"
      :key="comment.date"
    >
      {{ comment.text }}
      <br>
      <small>{{ new Date(comment.date).toLocaleString() }}</small>
    </div>

    <h6>Visits</h6>
    <p>Count: {{ visits.counterMessage }}</p>
    <p>{{ visits.trackerMessage }}</p>

    <h6>Session</h6>
    <button v-on:click="sessionLogin()">Login</button>
    <p>Login: {{ session.status }}</p>

    <h6>IP</h6>
    <p>{{ ipAddress }}</p>
  </div>
</template>

<script>
const axios = require("axios");

export default {
  name: "app",
  components: {},
  data: function() {
    return {
      petTypes: [
        { type: "nodejs", name: "nodejs", message: "" },
        { type: "python", name: "python", message: "" },
        { type: "java", name: "java", message: "" },
        { type: "php", name: "php", message: "" },
        { type: "go", name: "go", message: "" }
      ],
      comments: {
        origin: "",
        items: []
      },
      visits: {
        trackerMessage: "",
        counterMessage: "0"
      },
      commentInput: "",
      ipAddress: "",
      session: {
        id: "",
        status: "Not Logged In"
      }
    };
  },
  created: function() {
    this.refresh();
    this.trackVisit();
    this.getIp();
  },
  methods: {
    refresh: function() {
      for (var i = 0; i < this.petTypes.length; i++) {
        this.getPetInfo(i);
      }
      this.getComments();
      this.countVisit();
      this.sessionCheck();
    },
    getPetInfo: function(index) {
      axios
        .get(`/api-${this.petTypes[index].type}/`)
        .then(response => {
          this.petTypes[index].message = response.data;
        })
        .catch(() => {
          this.petTypes[index].message = "Error gettting content.";
        });
    },
    trackVisit: function() {
      axios
        .get(`/api-visits-tracker/`)
        .then(() => {
          this.visits.trackerMessage = "";
        })
        .catch(() => {
          this.visits.trackerMessage = "Error tracking visit";
        });
    },
    getIp: function() {
      axios
        .get(`/api-myip/`)
        .then(response => {
          this.ipAddress = response.data;
        })
        .catch(() => {
          this.ipAddress = "Error getting IP";
        });
    },
    countVisit: function() {
      axios
        .get(`/api-visits-counter/`)
        .then(response => {
          this.visits.counterMessage = response.data;
        })
        .catch(() => {
          this.visits.counterMessage = "Error counting visits";
        });
    },
    getComments: function() {
      axios
        .get(`/api-comments/`)
        .then(response => {
          this.comments = response.data;
        })
        .catch(() => {
          this.comments = { origin: "Error getting content", items: [] };
        });
    },
    postComment: async function() {
      const data = {
        text: this.commentInput
      };
      await axios.put(`/api-comments/`, data).catch(() => {
        this.comments = { origin: "Error getting content", items: [] };
      });
      this.commentInput = "";
      setTimeout(() => {
        this.getComments();
      }, 500);
    },
    sessionLogin: async function() {
      const data = {};
      await axios.post(`/api-session-login/`, data).then(response => {
        this.session.id = response.data.session_id;
        this.sessionCheck();
      });
    },
    sessionCheck: async function() {
      const data = { session_id: this.session.id };
      await axios
        .post(`/api-session-check/`, data)
        .then(response => {
          this.session.status = "Logged In";
        })
        .catch(error => {
          this.session.status = "Not Logged In";
        });
    }
  }
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  color: #2c3e50;
  margin: 2rem;
}

.card-pet {
  margin: 0.5rem;
}

h1 {
  margin-bottom: 1rem;
}

h6 {
  margin-top: 1rem;
}
</style>
