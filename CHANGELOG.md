# Changelog

## v2.0.0

-   Relax the requirements for `scrivener_ecto` to allow 1.x and 2.x
versions - thereby also allowing ecto 3.x,
resolves [issue 4](https://github.com/stephenmoloney/scrivener_list/issues/4)

-   README example without a Repo module no longer references
a Repo module confusingly - [PR](https://github.com/stephenmoloney/scrivener_list/pull/2)

-   Formatting introduced with `mix format`

-   Linting the `README.md` file

-   Add example in `README.md` of adding `adapter: Ecto.Adapters.Postgres` in the
    `use` statement when creating a `Repo` module as is required
    for Ecto 3+.

## v1.0.1

-   Cannot pass %Scrivener.Config.t into `Scrivener.Repo.paginate`. Change docs to reflect this.
-   Add `:scrivener_ecto` to `applications` and hence quieten warnings for releases.
-   bump dependencies & fix warnings for elixir 1.4.

## v1.0

-   Initial release.
