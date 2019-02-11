# Scrivener.List
[![Build Status](https://travis-ci.org/stephenmoloney/scrivener_list.svg)](https://travis-ci.org/stephenmoloney/scrivener_list)
[![Hex Version](http://img.shields.io/hexpm/v/scrivener_list.svg?style=flat)](https://hex.pm/packages/scrivener_list)
[![Hex docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/scrivener_list)

[Scrivener.List](https://hex.pm/packages/scrivener_list) is a Scrivener compatible extension that
allows the pagination of a list of elements.

## Features 

1.  Scrivener.List extends the protocol `Scrivener.Paginater.paginate/2` from the [scrivener](https://github.com/drewolson/scrivener) library.
1.  Scrivener.List also extends the function `MyApp.Repo.paginate/2` from the [scrivener_ecto](https://github.com/drewolson/scrivener_ecto) library.
    
Using the second feature is entirely optional. It's provided as a convenience where the [scrivener_ecto](https://github.com/drewolson/scrivener_ecto)
library is also being used in the project and gives access to the
pre-configured `MyApp.Repo` module.

## Usage

## 1. Usage without a Repo module 

```elixir
Scrivener.paginate(list, config)
```

### Arguments (without a repo)

-   ```list```: A list of elements to be paginated

-   ```config```: A configuration object with the pagination details.
    Can be in any of the following formats:
    -   ```%{page: page_number, page_size: page_size}``` (map)
    -   ```[page: page_number, page_size: page_size]``` (Keyword.t)
    -   ```%Scrivener.Config{page_number: page_number, page_size: page_size}``` (Scrivener.Config.t)

`max_page_size` **cannot** be configured with method 1.

### Examples

```elixir
def index(conn, params) do
  config = maybe_put_default_config(params)

  page = 
    ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
      "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
    |> Enum.map(&(&1 <> "  " <> "language"))
    |> Scrivener.paginate(config)

  render conn, :index,
    people: page.entries,
    page_number: page.page_number,
    page_size: page.page_size,
    total_pages: page.total_pages,
    total_entries: page.total_entries
end

defp maybe_put_default_config(%{page: page_number, page_size: page_size} = params), do: params
defp maybe_put_default_config(_params), do: %Scrivener.Config{page_number: 1, page_size: 10}
```

```elixir
list = ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
        
Scrivener.paginate(list, %Scrivener.Config{page_number: 1, page_size: 4}) # %Scrivener.Config{}
Scrivener.paginate(list, page: 1, page_size: 4) # keyword list
Scrivener.paginate(list, %{page: 1, page_size: 4}) # map
Scrivener.paginate(list, %{page: 1}) # map with only page number (page_size defaults to 10)
```

## 2. Usage with a Repo module

Usage without a Repo is entirely optional and is added to `Scrivener.List` for convenience. 
Firstly, see [Scrivener.Ecto](https://github.com/drewolson/scrivener_ecto) and configure the `MyApp.Repo` module.

### Example Repo configuration

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.Postgres
  use Scrivener,
    page_size: 10,
    max_page_size: 100
end
```

```elixir
MyApp.Repo.paginate(list, config)
```

### Arguments (with a repo)

-   ```list```: A list of elements to be paginated

-   ```config```: A configuration object with the pagination details.
    Can be in any of the following formats:
    -   ```%{page: page_number, page_size: page_size}``` (map)
    -   ```[page: page_number, page_size: page_size]``` (Keyword.t)

`max_page_size` **can** be configured with method 1. See [Scrivener.Ecto](https://github.com/drewolson/scrivener_ecto).

### Example

Example based on [scrivener_ecto](https://github.com/drewolson/scrivener_ecto) readme.

```elixir
def index(conn, params) do
  %{age: age, name: name} = params["search"] 
  
  page = MyApp.Person
  |> where([p], p.age > ^age)
  |> order_by([p], desc: p.age)
  |> preload(:friends)
  |> MyApp.Repo.all()
  |> Enum.filter(fn(person) -> person.data.friend.name = name end)
  |> MyApp.Repo.paginate(params)

  render conn, :index,
    people: page.entries,
    page_number: page.page_number,
    page_size: page.page_size,
    total_pages: page.total_pages,
    total_entries: page.total_entries
end
```

## Installation

Add [scrivener_list](https://hex.pm/packages/scrivener_list) to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scrivener_list, "~> 2.0"}
  ]
end
```

## Tests

```shell
MIX_ENV=test mix test
```

## Acknowledgements

The introduction of the [protocol](http://blog.drewolson.org/extensible-design-with-protocols/)
for scrivener enabled the separation of this package into it's own
repository.

## Licence

MIT
