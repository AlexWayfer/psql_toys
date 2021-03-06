# Changelog

## master (unreleased)

## 0.4.0 (2021-04-30)

*   Add Ruby 3 support.
*   Update development dependencies.
*   Add `bundle-audit` CI task (for security).
*   Update gem metadata in specs.

## 0.3.3 (2020-12-08)

*   Include `:exec` where needed, don't use `subtool_apply`.
    Avoid conflicts with `sequel_migration_toys`.
*   Update development dependencies.
*   Resolve offenses from new RuboCop.
*   Improve required Ruby version lock, avoid 3.0.

## 0.3.2 (2020-09-24)

*   Fix `create` tool.

## 0.3.1 (2020-09-11)

*   Require `memery` where necessary.

## 0.3.0 (2020-08-23)

*   Update `toys`.

## 0.2.0 (2020-08-02)

*   Move `subtool_apply` and dependencies requirements inside `tool :database`
*   Remove `unless include? :exec` condition, there should not be any `include :exec` outside.

## 0.1.0 (2020-07-13)

*   Initial release.
