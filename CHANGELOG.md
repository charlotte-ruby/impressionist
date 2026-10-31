# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/2.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.6.1] - 2018-04-16

### Added

- Add params filtering on new column. ([#246], [@rposborne])
- Add a DB migration to add params to schema. ([#245], [@rposborne])

### Fixed

- Add `belongs_to optional: true` to `setup_association`. ([#264], [@josephMG])
- Add missing field for Mongoid. ([#254], [@Fibrasek])
- Add the Rails major version to the migration file. ([#248], [@jordanhudgens])

## [1.6.0] - 2017-05-24

### Added

- Rails 5.1 support. ([#241], [@msimonborg])
- Documentation example for `counter_cache`. ([#239], [@fwolfst])

### Changed

- Use `dependent: :delete_all` instead of `:destroy` for performance gains. ([#242], [@midnightSuyama], [@jgrau])
- Green Travis CI builds. ([#238], [@jgrau])

### Fixed

- Fix counter cache not updating when no `unique` option is set. ([#243], [@sachiotomita], [@jgrau])

## [1.5.2] - 2016-09-16

## [1.5.1] - 2013-12-31

## [1.5.0] - 2013-12-30 [YANKED]

### Added

- Message filtering. ([@overovermind])

## [1.4.8] - 2013-09-05

### Changed

- Clean up. ([@acnalesso])

### Fixed

- Fix polymorphic associations working only one way. ([#108], [@acnalesso])

## [1.4.7] - 2013-08-30

### Fixed

- Allow impressions to be saved without a model. ([#103], [@acnalesso])
- Fix wrong documentation of the counter cache option. ([#104], [@acnalesso])

## [1.4.6] - 2013-08-17

### Fixed

- Count unique records in Rails 4. ([#106])

## [1.4.5] - 2013-07-19

### Fixed

- Fix `update_counters` raising an exception. ([#97])

## [1.4.4] - 2013-07-14

### Changed

- Update `templates/impression.rb`.

## [1.4.3] - 2013-07-14

### Changed

- Remove pending tests, add tags.

### Fixed

- Fix generators. ([#96])

## [1.4.2] - 2013-07-12

### Added

- Mongoid support.
- Two new entities.

### Changed

- Support Rails > 3.1 < 4.0.
- Add MiniTest, testing against impressionist (RSpec still tests `test_app`, to be removed soon).
- Move all tests into the `tests` dir.
- Clean up.

### Fixed

- Fix "Can't mass-assign protected attributes" error. ([#93])
- Fix failing Travis builds.

## [1.4.1] - 2013-07-06

### Added

- Test support. ([@acnalesso])

### Changed

- Create individual RSpec files. ([@acnalesso])

### Fixed

- Fix trailing space. ([@acnalesso])

## [1.4.0] - 2013-07-06

### Added

- Pass the `unique` option when updating `counter_cache`. ([@acnalesso])

### Changed

- Clean up code, make it human readable. ([@acnalesso])
- Explain the new features in the README. ([@acnalesso])

### Fixed

- Fix a non-existing item raising an exception that could not be prevented. ([#92], [@acnalesso])

## [1.3.3] - 2013-06-27 [YANKED]

### Added

- Rails 4 branch in order to support Rails 4.
- Rails 4 and Strong Parameters compatibility. ([@bennick])

## [1.3.1] - 2013-05-08

### Changed

- Change `controller_path` back to `controller_name`. ([@johnmcaliley])

## [0.4.0] - 2011-06-03

You must run the upgrade migration, `impressionist/upgrade_migrations/version_0_4_0.rb`, if you are upgrading from 0.3.0. If you are upgrading from 0.2.5 or below, you must run both upgrade migrations.

### Added

- New impression count method that accepts options for filter, `start_date` and `end_date`.
- **Breaking:** Add referrer to the `Impression` model, which requires the upgrade migration.

### Fixed

- Fix Postgres bug.

## [0.3.0] - 2011-03-06 [YANKED]

If you are upgrading from 0.2.5, run the migration in the `upgrade_migrations` dir.

### Added

- Add `session_hash` to the impression model.
- New count instance method for impressionable models: `unique_impression_count_session`.

### Changed

- Update the migration template to add `session_hash`.

## [0.2.5] - 2011-02-17 [YANKED]

### Added

- New model method `@widget.unique_impression_count_ip`, which gives you the unique impression count filtered by IP (and in turn `request_hash`, since they have the same IPs).

### Fixed

- `@widget.unique_impression_count` now uses `request_hash`. It was using `ip_address`, which the README incorrectly stated; the README is correct as a result of the method change.

## [0.2.4] - 2011-02-17 [YANKED]

### Fixed

- `action_name` and `controller_name` were not being logged for the `impressionist` method inside an action. ([#1])

[Unreleased]: https://github.com/charlotte-ruby/impressionist/compare/v2.0.0...HEAD
[1.6.1]: https://github.com/charlotte-ruby/impressionist/compare/v1.6.0...v1.6.1
[1.6.0]: https://github.com/charlotte-ruby/impressionist/compare/b96921d...v1.6.0
[1.5.2]: https://github.com/charlotte-ruby/impressionist/compare/1c3ac14...b96921d
[1.5.1]: https://github.com/charlotte-ruby/impressionist/compare/v1.5.0...1c3ac14
[1.5.0]: https://github.com/charlotte-ruby/impressionist/compare/v1.4.13...v1.5.0
[1.4.8]: https://github.com/charlotte-ruby/impressionist/compare/6004469...34df3e8
[1.4.7]: https://github.com/charlotte-ruby/impressionist/compare/v1.4.6...6004469
[1.4.6]: https://github.com/charlotte-ruby/impressionist/compare/v1.4.5...v1.4.6
[1.4.5]: https://github.com/charlotte-ruby/impressionist/compare/v1.4.4...v1.4.5
[1.4.4]: https://github.com/charlotte-ruby/impressionist/compare/v1.4.3...v1.4.4
[1.4.3]: https://github.com/charlotte-ruby/impressionist/compare/v1.4.2...v1.4.3
[1.4.2]: https://github.com/charlotte-ruby/impressionist/compare/v1.4.1...v1.4.2
[1.4.1]: https://github.com/charlotte-ruby/impressionist/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/charlotte-ruby/impressionist/compare/v1.3.3...v1.4.0
[1.3.3]: https://github.com/charlotte-ruby/impressionist/compare/v1.3.2...v1.3.3
[1.3.1]: https://github.com/charlotte-ruby/impressionist/compare/v1.3.0...v1.3.1
[0.4.0]: https://github.com/charlotte-ruby/impressionist/compare/v0.3.2...v0.4.0
[0.3.0]: https://github.com/charlotte-ruby/impressionist/compare/v0.2.5...v0.3.0
[0.2.5]: https://github.com/charlotte-ruby/impressionist/compare/v0.2.4...v0.2.5
[0.2.4]: https://github.com/charlotte-ruby/impressionist/compare/v0.2.3...v0.2.4

[#1]: https://github.com/charlotte-ruby/impressionist/issues/1
[#92]: https://github.com/charlotte-ruby/impressionist/issues/92
[#93]: https://github.com/charlotte-ruby/impressionist/issues/93
[#96]: https://github.com/charlotte-ruby/impressionist/issues/96
[#97]: https://github.com/charlotte-ruby/impressionist/issues/97
[#103]: https://github.com/charlotte-ruby/impressionist/issues/103
[#104]: https://github.com/charlotte-ruby/impressionist/issues/104
[#106]: https://github.com/charlotte-ruby/impressionist/pull/106
[#108]: https://github.com/charlotte-ruby/impressionist/issues/108
[#238]: https://github.com/charlotte-ruby/impressionist/pull/238
[#239]: https://github.com/charlotte-ruby/impressionist/pull/239
[#241]: https://github.com/charlotte-ruby/impressionist/pull/241
[#242]: https://github.com/charlotte-ruby/impressionist/pull/242
[#243]: https://github.com/charlotte-ruby/impressionist/pull/243
[#245]: https://github.com/charlotte-ruby/impressionist/pull/245
[#246]: https://github.com/charlotte-ruby/impressionist/pull/246
[#248]: https://github.com/charlotte-ruby/impressionist/pull/248
[#254]: https://github.com/charlotte-ruby/impressionist/pull/254
[#264]: https://github.com/charlotte-ruby/impressionist/pull/264

[@acnalesso]: https://github.com/acnalesso
[@bennick]: https://github.com/bennick
[@Fibrasek]: https://github.com/Fibrasek
[@fwolfst]: https://github.com/fwolfst
[@jgrau]: https://github.com/jgrau
[@johnmcaliley]: https://github.com/johnmcaliley
[@jordanhudgens]: https://github.com/jordanhudgens
[@josephMG]: https://github.com/josephMG
[@midnightSuyama]: https://github.com/midnightSuyama
[@msimonborg]: https://github.com/msimonborg
[@overovermind]: https://github.com/overovermind
[@rposborne]: https://github.com/rposborne
[@sachiotomita]: https://github.com/sachiotomita
