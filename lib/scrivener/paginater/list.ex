defimpl Scrivener.Paginater, for: List do
  # An implementation of the `Scrivener.Paginater` protocol to extend `Scrivener.Paginater.paginate/2`
  # to accept a list as the first argument in addition to Ecto.Query.t. 
  alias Scrivener.Config
  alias Scrivener.Page


  @doc """
  Paginates a list of elements and returns a `%Scrivener.Page{}`. A `%Scrivener.Config{}` struct
  or a keyword list or a map of pagination options can optionally be passed as the second argument.
  If no second argument is passed, a new `%Scrivener.Config{}` will be constructed using page
  number 1 and the default Repo settings.

  This module effectively polymorphically extends `Scrivener.Paginater.paginate/2` to accept
  a list as the first argument in addition to a query argument which is the standard type expected
  by the Scrivener project. This is achieved using elixir [protocols](http://elixir-lang.org/getting-started/protocols.html).

  Returns a `%Scrivener.Page{}` struct with useful information including:

  - page_size: The number of elements per page
  - page_number: The current page number
  - entries: A subset of elements from the list on this current page
  - total_entries: The total number of elements in the list
  - total_pages: The total number of pages

  The `paginate` function can also be called with a custom `Scrivener.Config` for more fine-grained configuration.

  ## Example config struct

      config = %Scrivener.Config{
        page_size: 5,
        page_number: 2,
        repo: MyApp.Repo
      }

  ## Example using a `%Scrivener.Config{}` struct

      ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
      |> MyApp.Repo.paginate(%Scrivener.Config{page_number: 1, page_size: 4})

  ## Example using a keyword list of options

      ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
      |> MyApp.Repo..paginate(page: 1, page_size: 4)

  ## Example using a map of options

      ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
      |> MyApp.Repo.paginate(%{page: 1, page_size: 4})

  ## Example using only the page number (page_size defaults to 10)

      ["C#", "C++", "Clojure", "Elixir", "Erlang", "Go", "JAVA", "JavaScript", "Lisp",
        "PHP", "Perl", "Python", "Ruby", "Rust", "SQL"]
      |> MyApp.Repo.paginate(%{page: 1})

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
