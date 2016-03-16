# ScrivenerList

[![Build Status](https://travis-ci.org/stephenmoloney/scrivener_list.svg)](https://travis-ci.org/stephenmoloney/scrivener_list) [![Hex Version](http://img.shields.io/hexpm/v/scrivener_list.svg?style=flat)](https://hex.pm/packages/scrivener_list) [![Hex docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/scrivener_list)

[ScrivenerList](https://hex.pm/packages/scrivener_list) is a Scrivener compatible extension that
allows one to paginate a list of elements.

ScrivenerList extends the functions `Scrivener.paginate/2` and `MyApp.Repo.paginate/2` such that
a list can be passed and the function returns pages in the %Scrivener.Page{} format, the same as scrivener.
[Scrivener](https://hexdocs.pm/scrivener/) is a required dependency but the creation of
a Repo module and `use Scrivener` statement therein is optional.

By adding `{:scrivener_list, "~> 0.9"}` to a project's list of dependencies, the `Scrivener.Paginater.paginate/2`
function is effectively polymorphically extended to accept a list as the first argument in addition to a
`Ecto.Query.t.` struct which is the standard type expected by the Scrivener project. This is achieved using
elixir [protocols](http://elixirlang.org/gettingstarted/protocols.html) and specifically the `Scrivener.Paginater.paginate/2` function.


## Motivation

To extend the capabilities of [Scrivener](https://hex.pm/packages/scrivener) to paginate a
list. Sometimes, a list returned from the DB needs to be modified in some way after the ecto
query is complete. This extension allows for the pagination of said lists.


## Usage

First, setup the scrivener as normal. See [scrivener docs](https://hexdocs.pm/scrivener/Scrivener.html)

If using a Repo, you'll want to add `use Scrivener, page_size: page_size` in your application's Repo. This will add a `paginate/2` function to the Repo module. If no database requests are being made using Ecto then
setting up a Repo module is an optional step with Scrivener since Scrivener can also paginate a list provided it is passed a list and a custom `%Scrivener.Config{}` struct, or keyword options or a map of options
by way of the `Scrivener.paginate/2` function. **Pending**

With Scrivener, there are two ways to make use of the `paginate` function:

## 1. Usage with a Repo module

#### Example

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo, otp_app: :my_app
  use Scrivener, page_size: 10, max_page_size: 100
end

defmodule MyApp.Team do
   use Ecto.Model
   schema "team" do
     field :name, :string
     field :size, :integer
     has_many :dev, MyApp.Team
   end
 end
 defmodule MyApp.Dev do
   use Ecto.Model
   schema "dev" do
     field :name, :string
     field :type, :string
     belongs_to :team, MyApp.Team
   end
 end

def index(conn, params) do
 page = MyApp.Repo.All(Team)
 |> MyApp.Repo.preload(dev: from(d in Dev, where: type == "elixir")
 |> Enum.map(&(&1.name <> "  " <> "elixir developer"))
 |> MyApp.Repo.paginate(params)

 render conn, :index,
   people: page.entries,
   page_number: page.page_number,
   page_size: page.page_size,
   total_pages: page.total_pages,
   total_entries: page.total_entries
end
```

#### Example

A Custom page number and page_size can be used

```elixir
page = MyApp.Repo.All(Team)
|> MyApp.Repo.preload(dev: from(d in Dev, where: type == "elixir")
|> Enum.map(&(&1.name <> "  " <> "elixir developer"))
|> MyApp.Repo.paginate(page: 2, page_size: 5)
```


## 2. Usage without a Repo module

Since the `%Scrivener.Config{}` struct is not configured when there is no Repo module, one of the following
must be passed in as the second argument to `Scrivener.paginate/2`:

**Pending**
 - ```%{page: page_number, page_size: page_size}```
 - ```[page: page_number, page_size: page_size]```
 - ```%Scrivener.Config{page_number: page_number, page_size: page_size}```
**Pending**


#### Example

```elixir
def index(conn, params) do
  config = maybe_put_default_config(params)

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

**Pending**
#### Example using a `%Scrivener.Config{}` struct

```elixir  
["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
  "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
|> MyApp.Repo.paginate(%Scrivener.Config{page_number: 1, page_size: 4})
```

#### Example using a keyword list of options

```elixir
["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
  "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
|> MyApp.Repo..paginate(page: 1, page_size: 4)
```

#### Example using a map of options

```elixir
["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
  "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
|> MyApp.Repo.paginate(%{page: 1, page_size: 4})
```

#### Example using only the page number (page_size defaults to 10)

```elixir
["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
  "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
|> MyApp.Repo.paginate(%{page: 1})
```
**Pending**

*Note:* Using method 2, it is currently not possible to set a max_page_size ceiling when using the
`Scrivener.paginate/2` function.


## Installation

Add [scrivener](https://hex.pm/packages/scrivener) and [scrivener_list](https://hex.pm/packages/scrivener_list) to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [
      {:scrivener_list, "~> 0.9"}
    ]
  end
```

Set up the Repo module for using scrivener

```elixir
  defmodule MyApp.Repo do
    use Ecto.Repo, otp_app: :my_app
    use Scrivener, page_size: 10, max_page_size: 100
  end
```

## Tests

```shell
  mix test
```


## Licence

MIT
