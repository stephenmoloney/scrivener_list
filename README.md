# ScrivenerList
[ScrivenerList](https://hex.pm/packages/scrivener_list) is a Scrivener compatible extension that
allows one to paginate a list of elements.

ScrivenerList returns pages in the %Scrivener.Page{} format, the same as scrivener.
[Scrivener](https://hexdocs.pm/scrivener/) is a required dependency but the creation of
a Repo module and `use Scrivener` statement therein is optional.

By adding `{:scrivener_list, "~> 1.0"}` to a project's list of dependencies, the `Scrivener.Paginater.paginate/2`
function is effectively polymorphically extended to accept a list as the first argument in addition to a
`Ecto.Query.t.` struct which is the standard type expected by the Scrivener project. This is achieved using
elixir [protocols](http://elixir-lang.org/getting-started/protocols.html).


## Motivation

To extend the capabilities of [Scrivener](https://hex.pm/packages/scrivener) to paginate a
list. Sometimes, a list returned from the DB needs to be modified in some way after the ecto
query is complete. This extension allows for the pagination of said lists.


## Usage

First, setup the scrivener as normal. See [scrivener docs](https://hexdocs.pm/scrivener/Scrivener.html)

If using a Repo,, you'll want to `use` Scrivener in your application's Repo. This will add a `paginate`
function to your Repo. If no database requests are being made then setting up a Repo module
is an optional step with ScrivenerList since ScrivenerList can also paginate a list provided it is
passed a list and a custom `%Scrivener.Config{}` struct.

With ScrivenerList, there are two ways to make use of the `paginate` function:

#### Usage with a Repo module and the `use` Scrivener setup

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
   |> preload(:dev: from(d in Dev, where: type == "elixir")
   |> Enum.map(&(&1.name <> " - " <> "elixir developer"))
   |> MyApp.Repo.paginate(params)

   render conn, :index,
     people: page.entries,
     page_number: page.page_number,
     page_size: page.page_size,
     total_pages: page.total_pages,
     total_entries: page.total_entries
 end
 ```

 A Custom page number and page_size can be passed

```elixir
 page = MyApp.Repo.All(Team)
 |> preload(:dev: from(d in Dev, where: type == "elixir")
 |> Enum.map(&(&1.name <> " - " <> "elixir developer"))
 |> MyApp.Repo.paginate(page: 2, page_size: 5)
 ```


#### Usage without an Ecto Repo

Since the %Scrivener.Config() is not configured using this method, one of the following
must be passed in as the second argument to ScrivenerList.paginate/2:

```%{page: page_number, page_size: page_size}```
or
```[page: page_number, page_size: page_size]```
or
```%Scrivener.Config{page_number: page_number, page_size: page_size}```


```elixir
  def index(conn, params) do
    params =
    case params do
      %Scrivener.Config{page_number: page_number, page_size: page_size} ->
        %Scrivener.Config{page_number: page_number, page_size: page_size}
      %{page: page_number, page_size: page_size} ->
        %{page: page_number, page_size: page_size}
      [page: page_number, page_size: page_size] ->
        [page: page_number, page_size: page_size]
      _ ->
        %Scrivener.Config{page_number: 1, page_size: 10}
    end

    ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
      "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
    |> Enum.map(&(&1 <> " - " <> "language"))
    |> ScrivenerList.paginate(params)

    render conn, :index,
      people: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
  end
```

  *Note:* Using method 2, it is not possible to set a max_page_size ceiling when using the
  `ScrivenerList.paginate/2` function.


## Installation

Add [scrivener](https://hex.pm/packages/scrivener) and [scrivener_list](https://hex.pm/packages/scrivener_list) to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [
      {:scrivener_list, "~> 0.1"}
    ]
  end
```

Set up the Repo file for scrivener

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
