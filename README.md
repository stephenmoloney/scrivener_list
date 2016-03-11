# ScrivenerList
ScrivenerList is a Scrivener compatible extension that allows you to paginate a list of elements. It gives you useful
information such as the total number of pages, the current page, and the current page's entries.


## Motivation

Why not just use Scrivener and pass an `%Ecto.Query.{}` into the paginate function every time?
Some specific operations may be needed to be applied to a list of results from Ecto after the query has been completed
and the resultant list still needs to be paginated. This is where ScrivenerList is useful.


## Usage

First, setup the scrivener as normal. See [scrivener docs](https://hexdocs.pm/scrivener/Scrivener.html)

```elixir
    defmodule MyApp.Repo do
      use Ecto.Repo, otp_app: :my_app
      use Scrivener, page_size: 10, max_page_size: 100
    end
```

Second, Retrieve a list of results using an Ecto Query, apply a change as required and paginate the list.

```elixir
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
      page = Repo.All(Team)
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


## Usage without an Ecto Repo

```elixir
    def index(conn, params) do
      [ "SQL", "JAVA", "JavaScript", "C#", "C++", "Python", "PHP", "Ruby", "Elixir", "Erlang", "Lisp", "Perl" ]
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


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

Add scrivener_list to your list of dependencies in `mix.exs`:

```elixir
    def deps do
      [{:scrivener_list, "~> 0.0.1"}]
    end
```


## Licence

MIT
