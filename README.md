# OpenBudget Core

[![Build Status](https://travis-ci.org/obudget/core.svg?branch=master)](https://travis-ci.org/obudget/core) [![Coverage Status](https://coveralls.io/repos/github/obudget/core/badge.svg?branch=master)](https://coveralls.io/github/obudget/core?branch=master)

## Overview

* [OpenBudget](https://openbudget.xyz) is an open source budgeting platform inspired by popular budgeting apps like [YNAB](https://youneedabudget.com) and [GoodBudget](https://goodbudget.com).
* This is an API backend that powers [OpenBudget UI](https://github.com/obudget/ui), which is also an open source project.
* A public deployment of this code is maintained at [api.openbudget.xyz/api](https://api.openbudget.xyz/api)

## Why Open Source?

* I started this project as a way for me to learn Elixir and ReactJS.
* I've been a fan of envelope budgeting since 2011 and I always found it a challenge to share my passion for budgeting with other people because a lot of the best budgeting apps are locked behind a paywall.
* Being open source ensures that anyone who uses this software will know what's going on under the hood. e.g. Prevent unethical situations or enforcing transparency.
* Another benefit of being open source is that anyone can contribute and improve OpenBudget for everyone.
* This project was inspired by [OpenDota](https://www.opendota.com). Their organization's cause inspired me to go open source with this project.

## Tech Stack

* Language: [Elixir](https://elixir-lang.org/)
* Web Framework: [Phoenix](http://phoenixframework.org/)
* Database: [PostgreSQL](https://www.postgresql.org/)

## Quick Start

```
git clone https://github.com/odota/core.git
cd core
mix deps.get
mix ecto.create
mix ecto.migrate
mix phx.server
```

Afterwards, open your favorite REST client and go to [localhost:4000/api](http://localhost:4000/api)
