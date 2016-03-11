defmodule ScrivenerList do
  @moduledoc ~S"""
  ScrivenerList is a Scrivener compatible extension that allows you to paginate a list of elements. It gives you useful
  information such as the total number of pages, the current page, and the current page's entries.

  ## Motivation

  Why not just use Scrivener and pass an `%Ecto.Query.{}` into the paginate function every time?
  Some specific operations may be needed to be applied to a list of results from Ecto after the query has been completed
  and the resultant list still needs to be paginated. This is where ScrivenerList is useful.

  ## Usage

  First, setup the scrivener as normal. See [scrivener docs](https://hexdocs.pm/scrivener/Scrivener.html)

      defmodule MyApp.Repo do
        use Ecto.Repo, otp_app: :my_app
        use Scrivener, page_size: 10, max_page_size: 100
        use Scrivener
      end

  Second, Retrieve a list of results using an Ecto Query, apply a change as required and paginate the list.

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

  ## Usage without an Ecto Repo

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

  """
  alias Scrivener.Config
  alias Scrivener.Page
  @fallback_config Config.new(:nil, %{}, %{})


  @doc """
  ScrivenerList can optionally be `use`d by an Ecto repository.

  When `use`d, an optional default for `page_size` can be provided. If `page_size` is not provided a default of 10 will
  be used.

  A `max_page_size` can also optionally can be provided. This enforces a hard ceiling for the page size, even
  if you allow users of your application to specify `page_size` via query parameters. If not provided, there will be no
  limit to page size.

      defmodule MyApp.Repo do
        use Ecto.Repo, ...
        use Scrivener
      end

      defmodule MyApp.Repo do
        use Ecto.Repo, ...
        use Scrivener, page_size: 5, max_page_size: 100
      end

  When `use` is called, a `paginate` function is defined in the Ecto repo. See the `paginate` documentation for more information.
  """
  defmacro __using__(_opts) do
    quote do

      @spec paginate(list, map | Keyword.t) :: Scrivener.Page.t
      def paginate(entries, options \\ []) when is_list(entries) do
        defaults = __MODULE__.scrivener_defaults()
        config = Config.new(__MODULE__, defaults, options)
        ScrivenerList.paginate(entries, config)
      end

    end
  end



  @doc """
  Paginates a list of elements. Returns a `%Scrivener.Page{}` struct with useful information including:
  - page_size: The number of elements per page
  - page_number: The current page number
  - entries: A subset of elements from the list on this current page
  - total_entries: The total number of elements in the list
  - total_pages: The total number of pages

  The `paginate` function can also be called with a custom `Scrivener.Config` for more fine-grained configuration.

      config = %Scrivener.Config{
        page_size: 5,
        page_number: 2,
        repo: MyApp.Repo
      }

  ## Example with an Ecto Repo

      page = Repo.All(Person)
      |> preload(:dev: from(d in Dev, where: type == "elixir")
      |> Enum.map(&(Map.put(&1, :name, String.Capitalize(&1.name) <> " (Elixir)"))
      |> MyApp.Repo.paginate(params)


  ## Example without an Ecto Repo

      [ "SQL", "JAVA", "JavaScript", "C#", "C++", "Python", "PHP", "Ruby", "Elixir", "Erlang", "Lisp", "Perl" ]
      |> ScrivenerList.paginate(%Scrivener.Config{page_number: 2, page_size: 3})
  """
  def paginate(entries, %Config{page_number: page_number, page_size: page_size}) do
      total_entries = length(entries)

      %Page{
        page_size: page_size,
        page_number: page_number,
        entries: entries(entries, page_number, page_size),
        total_entries: total_entries,
        total_pages: total_pages(total_entries, page_size)
      }
  end
  def paginate(entries, %Config{}) do
    paginate(entries, @fallback_config)
  end


  defp entries(entries, page_number, page_size) do
    offset = page_size * (page_number - 1)
    Enum.slice(entries, offset, page_size)
  end


  defp total_pages(total_entries, page_size) do
    ceiling(total_entries / page_size)
  end


  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t
      pos when pos > 0 ->
        t + 1
      _ -> t
    end
  end


end
