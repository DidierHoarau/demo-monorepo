const express = require('express');
const app = express();
const port = 80;

app.get('/', (req, res) => {
  res.send(
    `${req.headers['x-forwarded-for'] || req.connection.remoteAddress} (@${
      process.env.HOSTNAME
    })`
  );
});

app.listen(port, () => console.log(`App istening on port ${port}!`));
