const express = require('express');
const app = express();
const port = 80;

app.set('trust proxy', true);

app.get('/', (req, res) => {
  res.send(JSON.stringify(req.headers));
  // res.send(
  //   `x-real-ip: ${req.headers['x-real-ip']} ; x-forwarded-for: ${
  //     req.headers['x-forwarded-for']
  //   } ; address: ${req.connection.remoteAddress} (@${process.env.HOSTNAME})`
  // );
});

app.listen(port, () => console.log(`App istening on port ${port}!`));
