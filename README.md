# README

This apps has its pourpose just to exercise the development of simple api, 
with an authentication layer, and using Redis to store data.

* Ruby version:
Ruby 2.6
Rails 6.0

* System dependencies

Redis > 4.0

* Configuration
bundle install
cp config/master.key.dev config/master.key

* How to run the test suite
rails test

As being part of the requirement, I used the Redis as the main database for the app.
To that, I'm handling all the instructions to create and update the keys on Redis for the User model

I'm also using Redis to store authentication tokens that should be required on `POST /login` providing an username/password

On the login stage, I'm not considering the creation of the user, as it is just the authentication layer for the API.
So, the user is expected to exist before the login.

I though on make a sign-up part to allow the creation of an user without being previously logged, but I dismissed this idea, because it's a not common behavior for an API

After logged in, the user can access all endpoints from /user resource.
But it's good to notice that I'm not making references for ID, even because REdis does not have this restriction

So to fetch/update/delete users one can access /users/:username with the proper HTTP Command (GET, PUT/PATCH and DELETE)

The GET /users endpoint, users the Redis scan feature, that searches on ALL keys stored on redis database, even if they don't belong to the project, and then filtering with the match for the serched param.
That I can see a little bit as a flaw, but is the consequences of attending the requirement of having Redis as database

And because SCAN navigates on cursos without restricting on only the data that matches the searche keys, I implemented a larger amount of data to fetch 1000 registres on each pagination round, however, the amount of data actually fetched after the filter, might be inconsistent if the Redis database has already too much data from other projects.


For the authentication layer, I'm using Warden to serve as a middleware, to fail fast in the case of the access_token is not provided or expired
