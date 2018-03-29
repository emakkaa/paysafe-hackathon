# PAYW-Mobile

## Installation

Download and install [Node.js](https://nodejs.org/).

## Structure
PAYW Mobile uses feature based architecture. Every feature has a folder where are all related to the feature files - controllers, services, directives, tests, html and scss.

*Example:*

  - src
    - feature
      - feature-controller.js
      - feature-controller.spec.js
      - feature-service.js
      - feature-service.spec.js
      - feature-directive.js
      - feature-directive.spec.js
      - feature.html
      - feature.scss

## Run

  ```sh
$ npm install
$ bower install
$ gulp build
$ ionic serve
```

# Test

## Depdendencies
 - Karma
 - Jasmine
 - angular-mocks
 
## Configurations
  Custom **Karma** configurations in `karma.conf.js`.

## How to run tests?

**Note:** When the file is saved, all tests related to the changes, will re-run.

  ```sh
$ karma start

```

or

```sh
$ gulp tests
```

## Tests output
After every change there will be new output in `tests/report/index.html`

## Code coverage
After every change there will be new output in `tests/coverage/index.html`