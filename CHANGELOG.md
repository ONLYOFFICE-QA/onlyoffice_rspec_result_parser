# Change log

## master (unreleased)

### Fixes

* Fix failure for `get_total_result_of_rspec_html`,
  `get_failed_cases_count_from_html` 
  on empty string param

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