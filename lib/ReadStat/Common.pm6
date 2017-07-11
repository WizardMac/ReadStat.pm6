use v6;

unit package ReadStat;

constant LIB is export = "readstat";

enum ValueType is export <string-type int8-type int16-type int32-type float-type double-type string-ref-type>;
enum Measure is export <unknown-measure nominal ordinal scale>;
enum Alignment is export <unknown-alignment left center right>;
enum Error is export <no-error error-open error-read error-malloc error-user-abort
                      error-parse error-unsupported-compression error-unsupported-charset
                      error-column-count-mismatch error-row-count-mismatch error-row-width-mismatch
                      error-bad-format-string error-value-type-mismatch
                      error-write error-writer-not-initialized error-seek
                      error-convert error-convert-bad-string
                      error-convert-short-string error-convert-long-string
                      error-numeric-value-is-out-of-range
                      error-tagged-value-is-out-of-range
                      error-string-value-is-too-long
                      error-tagged-values-not-supported
                      error-unsupported-file-format-version
                      error-name-begins-with-illegal-character
                      error-name-contains-illegal-character
                      error-name-is-reserved-word
                      error-name-is-too-long
                      error-bad-timestamp
                      error-bad-frequency-weight
                      error-too-many-missing-value-definitions
                      error-note-is-too-long
                      error-string-refs-not-supported
                      error-string-ref-is-required
                      error-row-is-too-wide-for-page>;
enum Compress is export <compress-none compress-rows>;
