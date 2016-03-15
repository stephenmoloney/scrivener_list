defmodule ScrivenerList do
  @moduledoc ~S"""
  ScrivenerList is a Scrivener compatible extension that allows you to paginate a list of elements.
  ScrivenerList returns pages in the %Scrivener.Page{} format, the same as scrivener.
  [Scrivener](https://hexdocs.pm/scrivener/) is a required dependency but the creation of
  a Repo module and `use Scrivener` statement therein is optional.

  By adding `{:scrivener_list, "~> 1.0"}` to a project's list of dependencies, the `Scrivener.Paginater.paginate/2`
  function is effectively polymorphically extended to accept a list as the first argument in addition to a
  `Ecto.Query.t.` struct which is the standard type expected by the Scrivener project. This is achieved using
  elixir [protocols](http://elixir-lang.org/getting-started/protocols.html).

  If using a Repo,, you'll want to `use` Scrivener in your application's Repo. This will add a `paginate`
  function to your Repo. If no database requests are being made then setting up a Repo module
  is an optional step with ScrivenerList since ScrivenerList can also paginate a list provided it is
  passed a list and a custom `%Scrivener.Config{}` struct.

  With ScrivenerList, there are two ways to make use of the `paginate` function:

  ## Method 1: With a Repo module and the `use` Scrivener setup

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

       # Custom page number and page_size can be passed

       page = MyApp.Repo.All(Team)
       |> preload(:dev: from(d in Dev, where: type == "elixir")
       |> Enum.map(&(&1.name <> " - " <> "elixir developer"))
       |> MyApp.Repo.paginate(page: 2, page_size: 5)

   ## Method 2: With the ScrivenerList.paginate/2 function

      Since the %Scrivener.Config() is not configured using this method, one of the following
      must be passed in as the second argument to ScrivenerList.paginate/2:

      %{page: page_number, page_size: page_size}
      or
      [page: page_number, page_size: page_size]
      or
      %Scrivener.Config{page_number: page_number, page_size: page_size}

      ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
      |> ScrivenerList.paginate(%Scrivener.Config{page_number: 1, page_size: 40})

  *Note:* Using method 2, it is not possible to set a max_page_size ceiling. On the other hand,
  when a Repo module is setup and used for pagination purposes, a max_page_size may
  optionally be set which will set an absolute maximum for a page size regardless of the
  value passed into the second argument for page_size.
  """
  alias Scrivener.Paginater
  alias Scrivener.Config
  @scrivener_defaults page_size: 10

  @doc """
  Paginates a list of elements and returns a `%Scrivener.Page{}`. A `%Scrivener.Config{}` struct
  or a keyword list or a map of pagination options must be passed as the second argument.

  Returns a `%Scrivener.Page{}` struct with useful information including:

  - page_size: The number of elements per page
  - page_number: The current page number
  - entries: A subset of elements from the list on this current page
  - total_entries: The total number of elements in the list
  - total_pages: The total number of pages


  ## Example using a `%Scrivener.Config{}` struct

      ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
      |> ScrivenerList.paginate(%Scrivener.Config{page_number: 1, page_size: 4})

  ## Example using a keyword list of options

      ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
      |> ScrivenerList.paginate(page: 1, page_size: 4)

  ## Example using a map of options

      ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
      |> ScrivenerList.paginate(%{page: 1, page_size: 4})

  ## Example using only the page number (page_size defaults to to the page_size set in the Repo
        `use` Scrivener statement)

      ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
      |> ScrivenerList.paginate(%{page: 1})

  *Note:* It is not possible to set a max_page_size ceiling when using the `ScrivenerList.paginate/2`
  function.
  """
  @spec paginate(list, Scrivener.Config.t | Keyword.t | map) :: Scrivener.Page.t
  def paginate(entries, options \\ [])

  def paginate(entries, %Config{} = config) do
    Paginater.paginate(entries, config)
  end

  def paginate(entries, options) do
    config = Config.new(:nil, @scrivener_defaults, options)
    paginate(entries, config)
  end


end
