# Trackguests3

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix

## SCOTT Installation

mix phx.new trackguests2 --binary-id --database postgres
* mix phx.gen.auth Accounts User users
* mix phx.gen.release  
* mix phx.gen.live Accomodation Residence  residences  title:string address:string floor_count:integer logo:binary

mix phx.gen.live Accomodation Rooms rooms  title:string residence_id:references:residences floor:integer needs_fob:boolean memo:string accepts_guests:boolean

mix phx.gen.live Accomodation Persons persons name:string room_id:references:rooms sex:string memo:string resident:boolean visitor:boolean staff:boolean:false phone:string email:string