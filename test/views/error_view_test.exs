defmodule ReadQ.ErrorViewTest do
  use ReadQ.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do

    assert render(ReadQ.ErrorView, "404.json", []) ==
           %{"errors" => [%{title: "Not found", code: 404}]}
  end

  test "render 500.json" do
    assert render(ReadQ.ErrorView, "500.json", []) ==
           %{"errors" => [%{title: "Internal server error", code: 500}]}
  end

  test "render any other" do
    assert render(ReadQ.ErrorView, "505.json", []) ==
           %{"errors" => [%{title: "Internal server error", code: 500}]}
  end
end
