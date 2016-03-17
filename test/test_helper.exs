defmodule Scrivener.List.TestCase do
  use ExUnit.CaseTemplate
  using(opts) do
    quote do
      use ExSpec, unquote(opts)
    end
  end
end

defmodule Scrivener.Repo do
  use Ecto.Repo, otp_app: :scrivener_list
  use Scrivener, page_size: 5, max_page_size: 10
end

ExUnit.start()
