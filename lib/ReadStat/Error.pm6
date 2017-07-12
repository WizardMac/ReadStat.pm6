use v6;

unit enum ReadStat::Error is export <none
                      error-open error-read error-malloc error-user-abort
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
