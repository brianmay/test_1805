# Test1805

Reproduce https://github.com/phoenixframework/phoenix_live_view/issues/1805

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Reproduce problem

Note: This is stupid code. All logs are stored in memory. If you reload the
view the logs will disappear. But it illustrates a potential problem regardless.

0. Start the phx server. `iex -S mix phx.server`
1. Visit http://localhost:4000/logs. Observe logs get added one entry per second.
2. Click the "test" link. This will take you to
   http://localhost:4000/logs/test. But note if you go to the URL instead of
   clicking the link, the state will get reset.
3. Observe existing logs appear OK.
4. Observe that new logs do not get added.

Make the following change:

```diff
diff --git a/lib/test_1805_web/live/logs.ex b/lib/test_1805_web/live/logs.ex
index 4cc8e26..558eb40 100644
--- a/lib/test_1805_web/live/logs.ex
+++ b/lib/test_1805_web/live/logs.ex
@@ -61,8 +61,6 @@ defmodule Test1805Web.Live.Logs do
   end
 
   def logs(assigns) do
-    lines = assigns[:lines]
-
     ~H"""
         <table class="">
             <thead class="">
@@ -75,7 +73,7 @@ defmodule Test1805Web.Live.Logs do
             </thead>
 
             <tbody>
-                <%= for line <- lines do %>
+                <%= for line <- @lines do %>
                     <tr>
                         <td class=""><%= line.datetime |> Calendar.strftime("%Y-%m-%d %H:%M:%S") %></td>
                         <td class=""><%= inspect line.level %></td>
```

Now repeat the test, and observe that both views work.
