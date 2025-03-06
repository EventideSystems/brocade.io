[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
![check](https://github.com/EventideSystems/brocade.io/actions/workflows/check.yml/badge.svg)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-community-brightgreen.svg)](https://rubystyle.guide)

# brocade.io

Open GTIN / barcode &amp; product database

## Project Background

Over the years there have been several attempts at creating a freely accessible database of GTIN/barcodes and associated product data.

Many of these projects have either stalled or disappeared: the [Outpan API](https://www.outpan.com/developers.php) vanished without warning, [Open Product Data](http://product-open-data.com/download) doesn't appear to have been updated since 2014 and recently [Datakick](https://www.datakick.org/) announced they will be shutting down as of March 31, 2020.

There are still numerous commercial providers, but the number of freely accessible product data sources seems to be severely limited, with the [Internet UPC Database](https://www.upcdatabase.com/) being one of the few open services able to sustain itself. For a universal dataset, UPC and related data isn't universally accessible.

## Project Goals

### Open Access

The project aims to present as few barriers as possible to accessing GTIN and product data. The code for providing the service will be released as open source (see LICENSE for details) and wherever possible the data will be made available under open licenses.

There may be a need to apply some constraints - _e.g._ rate limiting or requiring authorisation for certain tasks - but these will only be introduced for the sake of performance, security or similar concerns.

### Federated/Distributed Data

The project _is not_ intended to be a single source of truth for product data. Instead the goal is to provide a framework for sharing product data between otherwise autonomous sources.

It's anticipated that the project will require novel protocols for federating data between disparate systems, and will be looking for inspiration from other distributed systems (_e.g._ DNS, Open Social, _etc_).

### Migration Path

The initial goal for this project is to establish a migration path for users of existing APIs - notably Datakick. One aim is to provide a Datakick-compatible endpoint for developers of Datakick-related libraries to target.

The database will be seeded using data sourced from Datakick, at least initially.

## Getting Started

This section will have to be added to as the project proceeds, but for now assume a technology stack based around Ruby on Rails and Postgres.

Assuming you're able to get the app installed, there is a basic seed file available using a recent download from
datakick.org. Install the data via the rake task:

```
[bundle exec] rails db:seed:datakick
```

NB There are about 6000 entries in the seed data, but it doesn't include any images.

## Accessing Brocade.io

You are welcome to use the Brocode instance found at https://brocade.io. Register a user account by clicking on the "Sign In" link and swap to the "Sign Up" tab before entering your email address and password. Once your account is confirmed you will be able to access other features.

### API Access

Read access to the API is unrestricted, but if you want to add or edit product items you will need an access token. 

Use the following `curl` command to fetch an access token, replacing `<your email address>` and `<your password>` as approproiate. NB We will be providing an easier mechanism to generate tokens in the UI. Please bear with us while we get the basics sorted out.

```
curl -X POST -d "grant_type=password&email=<your email address>&password=<your password>" https://www.brocade.io/oauth/token
```

The API will respond with a JSON payload containing your token, along the lines of:

```
{"access_token":"29bd3f1b-76ad-45c4-867f-179803f5246d","token_type":"Bearer","expires_in":7200,"created_at":1600087628}
```

Take note of the value of the `access_token` key (the `29bd3f1b...` GUID in the example). You'll use this to authenticate against the API.

CAUTION: Tokens are currently set to expire after 2 hours. We will be addressing this limitation in the future, once we've established this is a secure enough model. It should be sufficient for testing, but we can extend this if it's causing issues. 

Future plans include rolling out [PKCE](https://tools.ietf.org/html/rfc7636) to provide security for mobile apps or other implementations where a long-running token could be decompiled out of the app or otherwise compromised.

#### Retrieving Items

Read access will work without authentication, so a simple `curl` to the API endpoint, passing the GTIN of the product you are after will suffice. Retrieving the 'test' GTIN '00000000000000':

```
curl -v https://www.brocade.io/api/items/00000000000000
```

returns a JSON payload containing the sample data:

```
{"gtin14":"00000000000000","brand_name":"ayam","name":"testname","size":"081216382297","ingredients":"Chocolate","serving_size":"34g","servings_per_container":"10","calories":5,"fat_calories":5,"fat":0.5,"saturated_fat":0.5,"trans_fat":0.5,"polyunsaturated_fat":0.5,"monounsaturated_fat":0.5,"cholesterol":0,"sodium":0,"potassium":0,"carbohydrate":0,"fiber":0,"sugars":0,"protein":0,"author":"MyAuthor","publisher":"MyPublisher","pages":0,"alcohol_by_volume":40.0}
```

#### Creating and Updating Items

To create a new item, send a POST to the API:

```
curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer <your token>" -d '{"gtin":"00000000000002", "name":"test", "brand_name":"my brand", "properties": {"size":"11 inches"}}' https://www.brocade.io/api/items
```

Updating requires a PUT, adding the GTIN to the end of the URL:

```
curl -i -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer <your token>" -d '{"name":"new test", "brand_name":"new brand", "properties": {"size":"12 inches"}}' https://www.brocade.io/api/items/00000000000002
```

NB The JSON payload for creating/updating is slightly different to the data returned via read access. Where the data retrieved is a simple flat list of key/value pairs, when pushing data to the API you will need to nest property values (anything other than `gtin`, `name` or `brand_name`) as a set of key/value pairs assigned to the `properties` key:

```
{ 
  "gtin": "GTIN / barcode id",
  "name": "product name,
  "brand_name": "product brand",
  "properties": {
    "serving_size": "..",
    "ingredients": "..",
    ...
  }
}
```

Right now you can pretty well put any keys in here, but we're thinking of adding the idea of property "sets" - common attributes for similar products (_e.g._ for books allow the keys `author`, `number_of_pages`, _etc_ ). The UI has something like this now, but it's not currently supported in the API.

## TODO

* Import image data from Datakick
* Source more open product data
* Improve front-end UI, add capacity to manage tokens
* New `/products` endpoint with more features (leaving `/items` to avoid breaking the API early adopters)
* Implement [PKCE](https://tools.ietf.org/html/rfc7636)
* Introduce 'property sets'
* Clean up database, remove / fix non-GTIN14 records
