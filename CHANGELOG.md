### 2.2.0

* feat: add support for buttondown/up & moveto - **[@dbushong](https://github.com/dbushong)** [#42](https://github.com/groupon/webdriver-http-sync/pull/42)
  - [`35ea4ca`](https://github.com/groupon/webdriver-http-sync/commit/35ea4ca6f3fda0480925613c42d73f702e333100) **feat:** add support for buttondown/up & moveto


### 2.1.0

* Implement execute_async, async_script, timeouts methods - **[@w0rse](https://github.com/w0rse)** [#40](https://github.com/groupon/webdriver-http-sync/pull/40)
  - [`3520539`](https://github.com/groupon/webdriver-http-sync/commit/35205398efef9e238b67de35c3a8586c43572f6b) **feat:** Implement execute_async and async_script methods
  - [`111cb0e`](https://github.com/groupon/webdriver-http-sync/commit/111cb0e6d4d8460b5c68becdce23db0ec1db8610) **feat:** Implement timeouts method


### 2.0.3

* Include native code in package - **[@jkrems](https://github.com/jkrems)** [#39](https://github.com/groupon/webdriver-http-sync/pull/39)
  - [`5b2c904`](https://github.com/groupon/webdriver-http-sync/commit/5b2c90449bccd0174400f34c1895ab05fe5025b7) **fix:** Include native code in package


### 2.0.2

* Apply latest nlm generator - **[@i-tier-bot](https://github.com/i-tier-bot)** [#38](https://github.com/groupon/webdriver-http-sync/pull/38)
  - [`79c4d03`](https://github.com/groupon/webdriver-http-sync/commit/79c4d038288790c0da3be036d979737c17b2ebb2) **chore:** Apply latest nlm generator
  - [`4c66beb`](https://github.com/groupon/webdriver-http-sync/commit/4c66bebfe8d37e444ebdc0f8b8f5ab2a3bbb97f2) **chore:** Install g++ 4.8 on CI


2.0.1
-----
* Warn only for non-critical errors - @jkrems
  https://github.com/groupon/webdriver-http-sync/pull/37

2.0.0
-----
* Consistently fail on PhantomJS errors - @jkrems
  https://github.com/groupon/webdriver-http-sync/pull/35
* Revert "capture stack trace for failed tryParse" - @khoomeister
  https://github.com/groupon/webdriver-http-sync/pull/33
