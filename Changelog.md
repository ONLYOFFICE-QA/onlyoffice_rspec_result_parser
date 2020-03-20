# Change log

## master (unreleased)

### New features
* `ResultParser.parse_rspec_html` return failed count
* Add `ResultParser#passed_count` parsing
* Add `ResultParser#total_tests_count` parsing
* Add `ResultParser.parse_metadata` method
* Add `ResultParser#pending_count`

### Changes

* Remove unused `ResultParser.get_processing_of_rspec_html`

## 0.0.1
* Initial release of `onlyoffice_rspec_result_parser` gem
* All method accept filename or string with data
* Store `Example#page_url` and `Example#screenshot` as separate fields