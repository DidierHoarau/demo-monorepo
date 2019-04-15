const express = require('express');
const redis = require('redis');
const bodyParser = require('body-parser');
const { promisify } = require('util');

const client = redis.createClient({ host: 'demo-multitech-redis', port: 6379 });
const getAsync = promisify(client.get).bind(client);

client.on('error', err => {
  console.log('Redis Client Error ' + err);
});

const app = express();
const port = 80;
app.use(bodyParser.json());

app.post('/', async (req, res) => {
  try {
    if (!req.body.session_id) {
      throw new Error('no session id provided');
    }
    const session = JSON.parse(await getAsync(req.body.session_id));
    if (!session) {
      throw new Error('invalid session');
    }
    if (new Date(session.session_expiration_date) < new Date()) {
      throw new Error('session expired');
    }
    res.status(200).send({});
  } catch (error) {
    res.status(400).send({ error: error.message });
  }
});

app.listen(port, () => console.log(`App istening on port ${port}!`));
