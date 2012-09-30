Aerie
=====

Tiny app for storing and sharing a photo stream.

Development
-----------

Migrate:

    sequel -m db/migrations postgres://localhost/aerie-development
    heroku run 'sequel -m db/migrations $DATABASE_URL'
