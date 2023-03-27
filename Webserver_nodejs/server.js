const express = require('express');
const bodyParser = require('body-parser');

const app = express();
server_number = process.env.SERVER_NUMBER
let welcomeText = `Welcome to web server No. ${server_number}`;

app.use(
  bodyParser.urlencoded({
    extended: false,
  })
);

app.use(express.static('public'));

app.get('/', (req, res) => {
  res.send(`
    <html>
      <head>
        <link rel="stylesheet" href="styles.css">
      </head>
      <body>
        <section>
          <h2>Hello!</h2>
          <h3>${welcomeText}</h3>
        </section>
      </body>
    </html>
  `);
});

app.get('/healths', (req, res) => {
  console.log('HEALTH CHECK ENDPOINT');
  try {
    const message = `web-server-${server_number}`;
    res.status(200).json({
      host: message
    });
    console.log('HEALTH CHECK PASSED');
  } catch (err) {
    console.error('ERROR FETCHING GOALS');
    console.error(err.message);
    res.status(500).json({ message: 'HEALTH CHECK FAILED' });
  }
});

app.listen(80);
