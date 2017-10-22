# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/obudget/core/compare/v0.1.0...HEAD)

### Added

- This changelog.
- Add Budget resource (schema/endpoint).

### Changed

- Convert authentication error responses to JSON API.
- Require user authentication for User endpoints except create (`POST /users`).
- Require user authentication for Budget endpoints.
- Include location (`links` key) inside API response body instead of header.
- Change all Budget endpoints to only show budgets associated with the current logged-in user.

## 0.1.0 - 2017-10-08

### Added

- This project.
- Use JSON API spec as our preferred standard.
- Add Account resource (schema/endpoint).
- Add User resource (schema/endpoint).
- Add Token endpoint.
- Add user authentication through Token endpoint.
