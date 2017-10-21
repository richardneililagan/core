# OpenBudget Core

[![Build Status](https://travis-ci.org/obudget/core.svg?branch=master)](https://travis-ci.org/obudget/core) [![Coverage Status](https://coveralls.io/repos/github/obudget/core/badge.svg?branch=master)](https://coveralls.io/github/obudget/core?branch=master) [![Gitter chat](https://badges.gitter.im/obudget.png)](https://gitter.im/obudget)

[![Sponsor](https://app.codesponsor.io/embed/FtXSUnEDZhz4wUWaXdYz3wdD/obudget/core.svg)](https://app.codesponsor.io/link/FtXSUnEDZhz4wUWaXdYz3wdD/obudget/core)

## Overview

* [OpenBudget](https://openbudget.xyz) is an open source envelope budgeting platform inspired by popular budgeting apps like [YNAB](https://youneedabudget.com) and [GoodBudget](https://goodbudget.com).
* This is an API backend that powers [OpenBudget UI](https://github.com/obudget/ui), which is also an open source project.
* A public deployment of this code is maintained at [api.openbudget.xyz/api](https://api.openbudget.xyz/api)

## Why Open Source?

* I started this project as a way for me to learn Elixir and ReactJS.
* I've been a fan of envelope budgeting since 2011 and I always found it a challenge to share my passion for budgeting with other people because a lot of the best budgeting apps are locked behind a paywall.
* Being open source ensures that anyone who uses this software will know what's going on under the hood. e.g. Prevent unethical situations or enforcing transparency.
* Another benefit of being open source is that anyone can contribute and improve OpenBudget for everyone.
* This project was inspired by [OpenDota](https://www.opendota.com), which is an open source project for viewing data related to the popular game Dota 2. The reason why it's big and successful is because it's open source. I want to emulate what they did for this project.
* Honestly, this endeavor is too big for 1 person to do. I want to encourage other developers who are better skilled than I am to help out in this project by going all-in on open source.

## Tech Stack

* Language: [Elixir](https://elixir-lang.org/)
* Web Framework: [Phoenix](http://phoenixframework.org/)
* Database: [PostgreSQL](https://www.postgresql.org/)

## How to contribute

* Fork this repository
* Write your awesome feature/fix/refactor
* Create a pull request
* Wait for your PR to be reviewed and merged
* You're now a contributor!

## Quick Start

```
git clone https://github.com/obudget/core.git # or clone your own fork
cd core
mix deps.get
mix ecto.create
mix ecto.migrate
mix phx.server
```

Afterwards, open your favorite REST client and go to [localhost:4000/api](http://localhost:4000/api)

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
