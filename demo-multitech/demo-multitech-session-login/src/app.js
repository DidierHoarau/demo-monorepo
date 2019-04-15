const express = require('express');
const redis = require('redis');

const client = redis.createClient({ host: 'demo-multitech-redis', port: 6379 });

client.on('error', function(err) {
  console.log('Redis Client Error ' + err);
});

const app = express();
const port = 80;

app.post('/', (req, res) => {
  const session = {
    session_id: generateSessionId(),
    session_expiration_date: new Date(new Date().getTime() + 60 * 1000)
  };
  client.set(session.session_id, JSON.stringify(session), redis.print);
  res.status(201).send(session);
});

app.listen(port, () => console.log(`App istening on port ${port}!`));

function generateSessionId() {
  let text = '';
  const possible =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  for (var i = 0; i < 30; i++)
    text += possible.charAt(Math.floor(Math.random() * possible.length));
  return text;
}
