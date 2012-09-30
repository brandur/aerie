Aerie
=====

Development
-----------

Migrate:

    sequel -m db/migrations postgres://localhost/aerie-development
    heroku run 'sequel -m db/migrations $DATABASE_URL'
