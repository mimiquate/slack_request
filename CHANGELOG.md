# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.1] - 2024-08-28

### Fixed

- Typo in the function name recommended to use in deprecation warning

## [0.3.0] - 2024-08-22

### Added

- `SlackRequest.BodyReader.read_and_cache_body/2` as a rename of now deprecated `SlackRequest.BodyReader.read_body/2`.
- `SlackRequest.BodyReader.cached_body/0` as a rename of now deprecated `SlackRequest.BodyReader.get_raw_body/0`.

### Deprecated

- `SlackRequest.BodyReader.read_body/2`. Use `SlackRequest.BodyReader.read_and_cache_body/2` instead.
- `SlackRequest.BodyReader.get_raw_body/0`. Use `SlackRequest.BodyReader.cached_body/0` instead.

[0.3.1]: https://github.com/mimiquate/slack_request/compare/v0.3.0...v0.3.1/
[0.3.0]: https://github.com/mimiquate/slack_request/compare/v0.2.0...v0.3.0/
