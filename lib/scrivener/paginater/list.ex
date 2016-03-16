defimpl Scrivener.Paginater, for: List do
  # An implementation of the `Scrivener.Paginater` protocol to extend `Scrivener.Paginater.paginate/2`
  # to accept a list as the first argument in addition to Ecto.Query.t.
  alias Scrivener.Config
  alias Scrivener.Page



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
