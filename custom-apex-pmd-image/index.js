const express = require('express');
const bodyParser = require("body-parser");
const ApexPMD = require('./ApexPMD');

const app = express();

app.use(bodyParser.json({ limit: '50mb' }));

app.get('/', (_, res) => res.send('Ok. Ver:2.5.0. Ver.PMD: 6.48.0'));
app.get('/server/log', (_, res) => res.send(''));
app.post('/apexPMD', handleAnalysisRequest);
app.post('/oauth/token', handleTokenRequest);

const port = process.env.PORT || 5000;
app.listen(port, () => console.log(`Port: ${port}`));

function handleAnalysisRequest(req, res) {
  console.log('Starting to handle analysis request.');
  try {
    console.log('Request body: %o', req.body);
    const { backUrl, sId, jobId, attList, attRuls, branchId } = req.body;
    
    async function controlAsync() {
      try {
        console.log('Starting PMD analysis.')

        const init = new ApexPMD(backUrl, sId, jobId, attList, attRuls, branchId);
        const steps = [ init.getAttachment, init.getRuls, init.runPMD, init.saveResults, init.updateObjects, init.cleanFolder ];

        while (init.isContinue) {
          for (const step of steps) {
            const result = await step.call(init);
            console.log('Step %s => %o', step.name, result);
          }
        }
      } catch (error) {
        console.error(error);
        throw error;
      }
    };

    controlAsync();

    res.status(200).json({ isSuccess: true, opStatus: 'INPROGRESS' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ isSuccess: false, opStatus: 'INTERNALERROR' });
  }
}

// why? :(
function handleTokenRequest(req, res) {
  console.log('Starting to handle token request.');

  const user = "admin";
  const pass = "n2c99skEwmWvt3Q1p7d11ne4FKwPqCs85N2RvwNdlfMw4I3NL";
  const username = req.query.username;
  const password = req.query.password;

  if (username == user && password == pass) {
    if (req.headers.authorization && req.headers.authorization.search('Basic ') === 0) {
      // fetch login and password
      const userEnv = process.env.username;
      const passEnv = process.env.password;

      if (new Buffer.from(req.headers.authorization.split(' ')[1], 'base64').toString() == userEnv + ':' + passEnv) {
        const auth = {
          access_token: 'a54c0200-5f3b-4625-b231111112131213',
          token_type: 'bearer',
          refresh_token: '475b9443-9cef-4468-a4be-e3f449da8d03',
          expires_in: 1867,
          scope: 'read write trust'
        };

        res.send(auth);
      } else {
        res.send('wrong username or password');
      }
    } else {
      res.send('not authorization');
    }
  } else {
    res.send('not authorization');
  }
}
