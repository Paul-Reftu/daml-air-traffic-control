[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/digital-asset/daml/blob/main/LICENSE)

# Air Traffic Control DAML Model

![air-traffic-control-workflow drawio-5](https://user-images.githubusercontent.com/47919865/180663689-6b1f0f0e-4255-4459-9b37-ca55341ee104.png)

DAML prototype for an ATC system. Allows modelling for an arbitrary number of gates, taxiways, runways and planes. Exceptions handled appropriately and test suite for flight departures and arrivals provided.

Further, we supply a PRISM model for formal verification, see program graph below and `prism` for more information.

![Bild 24 07 22 um 22 02](https://user-images.githubusercontent.com/47919865/180663869-f47e4f7f-d66d-4ed9-90ee-69f77ead7ba3.jpg)

The rest of this README contains auto-generated instructions for development setup.

# air-traffic-control

See [documentation] for details.

[documentation]: https://docs.daml.com/getting-started/installation.html

Please ask for help on [the Daml forum] if you encounter any issue!

[the Daml forum]: https://discuss.daml.com

## Development Quick Start

You need to have [Node.js] and [Daml] installed.

[Node.js]: https://nodejs.dev
[Daml]: https://docs.daml.com

First, start the Daml components:

```bash
daml start
```

This will:

- Build you Daml code once.
- Generate JavaScript code (and TypeScript definitions) for your Daml types.
- Start a Daml sandbox gRPC server (on 6865).
- Start a Daml HTTP JSON API server (on 7575).
- Watch for the `r` key press (`r` + Enter on Windows); when pressed, rebuild
  all of the Daml code, push the new DAR to the ledger, and rerun the JS/TS
  code generation.

Next, start the JS dev server:

```bash
cd ui
npm install
npm start
```

This starts a server on `http://localhost:3000` which:

- Builds all of your TypeScript (or JavaScript) code (including type
  definitions from the codegen).
- Serves the result on :3000, redirecting `/v1` to the JSON API server (on
  `localhost:7575`) so API calls are on the same origin as far as your browser
  is concerned.
- Watch for changes in TS/JS code (including codegen), and immediately rebuild.

## Deploying to Daml Hub

To build everything from scratch:

```bash
daml build
daml codegen js .daml/dist/air-traffic-control-0.1.0.dar -o ui/daml.js
cd ui
npm install
npm run-script build
zip -r ../air-traffic-control-ui.zip build
```

Next you need to create a ledger on [Daml Hub], upload the files
`.daml/dist/air-traffic-control-0.1.0.dar` (created by the `daml build` command)
and `air-traffic-control-ui.zip` (created by the `zip` command based on the result
of `npm run-script build`).

[Daml Hub]: https://hub.daml.com

Once both files are uploaded, you need to tell Daml Hub to deploy them. A few
seconds later, your website should be up and running.
