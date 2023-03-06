# Alma Unset Acq Tag

Scripts for creating an Itemized set of Process Type=Acquisition only Physical Titles and changing the Management Tags to "Don't Publish".

## Setting up Alma Unset Acq Tag

Clone the repo

```
git clone git@github.com:dfulmer/alma-unset-acq-tag.git
cd alma-unset-acq-tag
```

copy .env-example to .env

```
cp .env-example .env
```

edit .env with actual environment variables

build container
```
docker-compose build
```

bundle install
```
docker-compose run --rm app bundle install
```

start container
```
docker-compose up -d
```

## Creating a set and changing the Management Tags

1. This command will run the create_set.rb script, which combines two sets into an Itemized set:
```
docker-compose run --rm app bundle exec ruby create_set.rb
```

2. This command will run the set_tags.rb script, which will change the Management Tags of the newly created set to "Don't Publish":
```
docker-compose run --rm app bundle exec ruby set_tags.rb
```