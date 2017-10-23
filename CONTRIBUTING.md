# How To Contribute

We love pull requests from everyone. Reading this document means you're considering to take time out of your busy schedule to contribute to this project and that is most appreciated.

By participating in this project, you agree to abide by [our code of conduct](CODE_OF_CONDUCT.md).

## Getting Started

First of all, make sure that you have Elixir and PostgreSQL installed on your machine.

* [How to install Elixir](https://elixir-lang.org/install.html)
* [How to install PostgreSQL](https://wiki.postgresql.org/wiki/Detailed_installation_guides)

Afterwards, fork this project, then clone your repo:

```
git clone git@github.com:your-username/core.git
```

Get the dependencies needed for this project:

```
mix deps.get
```

Setup your database for local development:

```
mix ecto.create # Create the database
mix ecto.migrate # Perform the database migrations needed by the project
```

Finally, start Phoenix's local server so you can run your app in development:

```
mix phx.server
```

Since this project is just an API backend for [OpenBudget UI](https://github.com/obudget/ui), simply firing up a browser won't work if you want to interact with the API manually.

In order to interact with the API, you will need to use a REST client. Here are some suggestions:

* [Postman](https://www.getpostman.com/)
* [Advance REST Client](https://advancedrestclient.com/)
* [Insomnia](https://insomnia.rest/)

The API is located (by default) at http://localhost:4000/api

You can get a list of available API endpoints by executing this in your terminal:

```
mix phx.routes
```

## Coding Standards

When contributing, please follow the coding standards mentioned below so we can have nice and consistent-looking code that's easy to read for everyone.

### EditorConfig

Use an editor (or a plugin for your editor) that supports [EditorConfig](http://editorconfig.org).

Our [.editorconfig file](.editorconfig) should set your editor to OpenBudget's preferred settings automatically:

* [UTF-8 charset](https://en.wikipedia.org/wiki/UTF-8)
* [Unix-style line breaks](http://www.cs.toronto.edu/~krueger/csc209h/tut/line-endings.html)
* [End file with a newline](https://stackoverflow.com/questions/729692/why-should-text-files-end-with-a-newline)
* [No trailing whitespace before a line break](https://softwareengineering.stackexchange.com/questions/121555/why-is-trailing-whitespace-a-big-deal)
* [Use 2 spaces instead of tabs for indentation](https://github.com/rrrene/elixir-style-guide#spaces-indentation)

### Credo

To ensure code quality, we're using [Credo](https://github.com/rrrene/credo), a code analysis tool that follows the [Elixir Style Guide](https://github.com/rrrene/elixir-style-guide).

Before pushing your code, make sure to check if the quality of your code is good by doing the following command:

* `mix credo --strict`

If you get no errors from Credo, your pull request will most likely be accepted.

### Testing and Code Coverage

Writing tests for the code that you've written is strongly encouraged. This ensures the integrity of the code that you've written.

Before pushing your code, make sure that all tests are passing to know that your changes aren't breaking anything by doing the following command:

* `mix test`

Aside from that, your tests also need to cover all of the code that you've written. Otherwise, we're not really sure if the tests do what they're supposed to do:

* `mix coveralls`

### Additional Notes

* Add as many comments and documentation as you need for the code that you're going to write. OpenBudget should be accessible for developers of all experience and skill levels. Better to have too many than none at all.
* Don't be shy about adding line breaks between your code. A couple of empty lines between blocks of code can really improve readability.