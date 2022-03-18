
require('dotenv').config();
// const { start } = require('botbuilder-dialogs-adaptive-runtime-integration-express');
const { start,  makeServer, Options } = require('botbuilder-dialogs-adaptive-runtime-integration-restify');
const { getRuntimeServices} = require('botbuilder-dialogs-adaptive-runtime');
(async function () {
  try {
    const options = {
      logErrors: true,
      messagingEndpointPath: '/api/messages',
      skillsEndpointPrefix: '/api/skills',
      port: 3978,
      staticDirectory: 'wwwroot',
  };
//  await start(process.cwd(), "settings", defaultOptions);
const [services, configuration] = await getRuntimeServices(process.cwd(),  "settings");

const server = await makeServer(services, configuration, process.cwd(), options);

server.listen(options.port, () => console.log(`server listening on port ${options.port}`));
server.get('/', (req, res, next) => {
  res.send(200);
  next();
});

  } catch (err) {
    console.error(err);
    process.exit(1);
  }
})();

