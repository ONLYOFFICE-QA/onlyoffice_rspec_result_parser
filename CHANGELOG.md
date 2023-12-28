# Change log

## master (unreleased)

### New Features

* Add `ruby-3.2` in CI
* Add `ruby-3.3` to CI

### Changes

* Drop `ruby-2.6`, `ruby-2.7` support since it's EOL'ed

## 1.0.0 (2022-02-17)

### New Features

* Add `ruby-3.1` in CI
* Add `yamllint` check in CI

### Fixes

* Fix `markdownlint` failure because of old `nodejs` in CI
* Fix incorrect screenshot link if spec failure has several same links

### Changes

* Require `mfa` for releasing gem
* Remove `ruby-2.5` from CI since it's EOLed
* Remove `codeclimate` config, since we don't use it any more
* Check `dependabot` at 8:00 Moscow time daily

## 0.2.0 (2020-12-29)

### New Features

* Support of `rubocop-performance`, `rubocop-rake`
* Add `markdownlint` check in CI
* Add `rubocop` check in CI
* Add `yard` check that 100% code is documented
* Add `dependabot` config
* Add `ruby-3.0` to CI

### Changes

* Drop support of ruby < 2.5, since them EOLed
* Use GitHub Actions instead of TravisCI
* Remove support of `codecov`
* Freeze all dependencies version in Gemfile.lock
* Change `RspecResult#parse_page` param to keyword argument
* Add missing documentation
* Use `sh` command for better logging in rake release task
* Move repo to `ONLYOFFICE-QA` org

## 0.1.2 (2020-04-03)

### Fixes

* Do not fail if `get_total_result_of_rspec_html` recieve junk data

## 0.1.1 (2020-03-24)

### Fixes

* Fix failure for `get_total_result_of_rspec_html`,
  `get_failed_cases_count_from_html`
  on empty string param
* Fix markdown issues

## 0.1.0 (2020-03-20)

### New features

* `ResultParser.parse_rspec_html` return failed count
* Add `ResultParser#passed_count` parsing
* Add `ResultParser#total_tests_count` parsing
* Add `ResultParser.parse_metadata` method
* Add `ResultParser#pending_count`
* Add rake task for release gem on github packages

### Changes

* Remove unused `ResultParser.get_processing_of_rspec_html`
* Cleanup gem metadata

## 0.0.1

* Initial release of `onlyoffice_rspec_result_parser` gem
* All method accept filename or string with data
* Store `Example#page_url` and `Example#screenshot` as separate fields
