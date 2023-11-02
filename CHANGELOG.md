# Changelog

## Unreleased

## 0.8.0 (2023-11-02)

*   Update `toys` dependencies.
*   Update development dependencies.

## 0.7.0 (2023-07-05)

*   Add `create_user` toy.
    It creates a project user using superuser.
*   Drop Ruby 2.6 support.
    It has reached the end of life (even security),
    and it's not supported by new RuboCop version.
*   Add Ruby 3.2 support.
*   Move development dependencies from gemspec into Gemfile.
*   Update development dependencies.
*   Resolve new RuboCop offenses.

## 0.6.0 (2022-10-22)

*   Update `toys-core`.
*   Update `rubocop`.
*   Update badges in README.

## 0.5.1 (2022-09-24)

*   Allow `gorilla_patch` version 5.
*   Update development dependencies.
*   Improve CI.

## 0.5.0 (2022-08-10)

*   Add Ruby 3.1 support.
*   Drop Ruby 2.5 support.
*   Update dependencies.

## 0.4.2 (2021-10-18)

*   Update development dependencies.
*   Resolve new RuboCop offenses.

## 0.4.1 (2021-08-25)

*   Update development dependencies.

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
