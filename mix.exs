defmodule ScrivenerList.Mixfile do
  use Mix.Project

  def project do
    [
     app: :scrivener_list,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps,
     docs: [
       main: Scrivener.List,
       readme: "README.md"
     ]
    ]
  end


  def application do
    [applications: [:logger]]
  end


  defp deps do
    [
     {:scrivener, "~> 1.0"},
     {:og, "~> 0.0", only: :dev},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}
    ]
  end


  defp descriptions do
    ~S"""
    Paginate a list.

    Compatible with [Scrivener](https://github.com/drewolson/scrivener).
    """
  end


  defp package do
    [
      maintainers: ["Stephen Moloney"],
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/stephenmoloney/scrivener_list"},
      files: [
        "lib/scrivener_list.ex",
        "lib/scrivener_list",
        "mix.exs",
        "README.md"
      ]
    ]
  end


end
